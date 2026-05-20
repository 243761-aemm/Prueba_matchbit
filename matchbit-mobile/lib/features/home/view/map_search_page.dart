// lib/features/home/view/map_search_page.dart
//
// Pantalla que implementa el esquema del diagrama:
//   1. Barra de búsqueda con Places Autocomplete
//   2. Google Maps donde el usuario puede tocar para seleccionar destino
//   3. Reverse Geocoding al tocar el mapa
//   4. Consulta al microservicio de tarifas
//   5. Bottom sheet con resumen (tarifa básica y premium)
//   6. Navega a VehicleSelectionPage con DestinationModel

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

// Ajusta el package name según tu proyecto
import 'package:taxis/core/services/maps_service.dart';
import 'package:taxis/core/services/tarifa_service.dart';
import 'package:taxis/core/models/destination_model.dart';
import 'package:taxis/features/home/view/vehicle_selection_page.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage>
    with SingleTickerProviderStateMixin {
  // ── Constantes de color (igual que el resto de la app) ────────────────────
  static const purpleMain  = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);
  static const purpleMid   = Color(0xFFE4DEFF);
  static const bgColor     = Color(0xFFF7F8FC);

  // Aeropuerto TGZ – cámara inicial del mapa
  static const LatLng _origenLatLng = LatLng(16.5636, -93.0225);

  // ── Estado ────────────────────────────────────────────────────────────────
  GoogleMapController? _mapController;
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<PlaceSuggestion> _sugerencias = [];
  bool _mostrandoSugerencias = false;
  bool _cargando = false;

  Marker? _destinoMarker;
  DestinationModel? _destinoSeleccionado;

  // Session token para agrupar llamadas de Autocomplete + Details
  String _sessionToken = const Uuid().v4();

  // Debounce para no llamar la API en cada tecla
  DateTime _ultimaEscritura = DateTime.now();

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _mapController?.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ── Búsqueda con debounce (300ms) ─────────────────────────────────────────
  void _onSearchChanged(String value) {
    _ultimaEscritura = DateTime.now();
    final capturedTime = _ultimaEscritura;

    Future.delayed(const Duration(milliseconds: 300), () async {
      if (_ultimaEscritura != capturedTime) return; // otra tecla llegó
      if (!mounted) return;

      final sugerencias = await MapsService.instance.autocomplete(
        value,
        sessionToken: _sessionToken,
      );
      if (!mounted) return;
      setState(() {
        _sugerencias = sugerencias;
        _mostrandoSugerencias = sugerencias.isNotEmpty;
      });
    });
  }

  // ── Selección de sugerencia del autocomplete ──────────────────────────────
  Future<void> _seleccionarSugerencia(PlaceSuggestion s) async {
    setState(() {
      _cargando = true;
      _mostrandoSugerencias = false;
      _searchCtrl.text = s.mainText;
    });
    _searchFocus.unfocus();

    // 1. Obtener lat/lng con Place Details
    final detalle = await MapsService.instance.getPlaceDetail(
      s.placeId,
      sessionToken: _sessionToken,
    );

    // Reinicia el session token para la próxima búsqueda
    _sessionToken = const Uuid().v4();

    if (detalle == null || !mounted) {
      setState(() => _cargando = false);
      return;
    }

    await _procesarDestino(detalle);
  }

  // ── Tap en el mapa ────────────────────────────────────────────────────────
  Future<void> _onMapTap(LatLng pos) async {
    setState(() {
      _cargando = true;
      _mostrandoSugerencias = false;
    });
    _searchFocus.unfocus();

    // Reverse geocoding
    final detalle = await MapsService.instance.reverseGeocode(
      pos.latitude,
      pos.longitude,
    );

    if (detalle == null || !mounted) {
      setState(() => _cargando = false);
      return;
    }

    _searchCtrl.text = detalle.name;
    await _procesarDestino(detalle);
  }

  // ── Flujo común: detalle → tarifa → mostrar ───────────────────────────────
  Future<void> _procesarDestino(PlaceDetail detalle) async {
    // 2. Consultar microservicio de tarifas
    final destino = await TarifaService.instance.construirDestino(
      nombre: detalle.name,
      direccionCompleta: detalle.formattedAddress,
      placeId: detalle.placeId,
      lat: detalle.lat,
      lng: detalle.lng,
    );

    if (!mounted) return;

    // 3. Colocar marcador y mover cámara
    final marker = Marker(
      markerId: const MarkerId('destino'),
      position: LatLng(detalle.lat, detalle.lng),
      infoWindow: InfoWindow(title: detalle.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(detalle.lat, detalle.lng),
        13.0,
      ),
    );

    setState(() {
      _destinoMarker = marker;
      _destinoSeleccionado = destino;
      _cargando = false;
    });
  }

  // ── Navegar a selección de vehículo ───────────────────────────────────────
  void _confirmarDestino() {
    if (_destinoSeleccionado == null) return;

    // Pasamos DestinationModel a VehicleSelectionPage
    // VehicleSelectionPage necesita adaptarse para recibir este modelo.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleSelectionPage(
          destino: _destinoSeleccionado!.nombre,
          km: _destinoSeleccionado!.kmTexto,
          // Si quieres pasar el modelo completo, agrega el parámetro:
          // destinationModel: _destinoSeleccionado,
        ),
      ),
    );
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // ── Google Maps ───────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _origenLatLng,
              zoom: 12,
            ),
            onMapCreated: (c) => _mapController = c,
            onTap: _onMapTap,
            markers: {
              // Marcador fijo: aeropuerto (origen)
              const Marker(
                markerId: MarkerId('origen'),
                position: _origenLatLng,
                infoWindow: InfoWindow(
                  title: 'Aeropuerto TGZ',
                  snippet: 'Tu punto de salida',
                ),
              ),
              if (_destinoMarker != null) _destinoMarker!,
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ── Header + buscador ─────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                if (_mostrandoSugerencias) _buildSugerencias(),
              ],
            ),
          ),

          // ── Loading overlay ───────────────────────────────────────────────
          if (_cargando)
            Positioned(
              bottom: _destinoSeleccionado != null ? 220 : 40,
              left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: purpleMain,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Consultando tarifas...',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),

          // ── Bottom sheet: resumen del destino ─────────────────────────────
          if (_destinoSeleccionado != null && !_cargando)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildDestinoSheet(),
            ),

          // ── Hint "toca el mapa" cuando no hay destino ─────────────────────
          if (_destinoSeleccionado == null && !_cargando &&
              !_mostrandoSugerencias)
            Positioned(
              bottom: 32,
              left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app_rounded,
                          color: purpleMain, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Toca el mapa para seleccionar destino',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Widgets internos ──────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          // Botón atrás
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                  )
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_rounded,
                  size: 18, color: Color(0xFF1A1A2E)),
            ),
          ),
          const SizedBox(width: 12),
          // Origen
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.flight_land_rounded,
                    color: purpleMain, size: 15),
                SizedBox(width: 6),
                Text(
                  'Aeropuerto TGZ · Origen',
                  style: TextStyle(
                    color: purpleMain,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        focusNode: _searchFocus,
        onChanged: _onSearchChanged,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: 'Buscar destino, colonia o dirección...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded,
              color: Colors.grey.shade400, size: 22),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close_rounded,
                color: Colors.grey.shade400),
            onPressed: () {
              _searchCtrl.clear();
              setState(() {
                _sugerencias = [];
                _mostrandoSugerencias = false;
                _destinoSeleccionado = null;
                _destinoMarker = null;
              });
            },
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSugerencias() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _sugerencias.length > 6 ? 6 : _sugerencias.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: Color(0xFFF5F5F5),
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (_, i) {
          final s = _sugerencias[i];
          return InkWell(
            onTap: () => _seleccionarSugerencia(s),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: purpleLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.place_rounded,
                        color: purpleMain, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.mainText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        if (s.secondaryText.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            s.secondaryText,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinoSheet() {
    final d = _destinoSeleccionado!;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 24,
            offset: Offset(0, -4),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nombre del destino
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: purpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.place_rounded,
                    color: purpleMain, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      d.direccionCompleta,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: purpleLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  d.kmTexto,
                  style: const TextStyle(
                    color: purpleMain,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 16),

          // Tarifas
          Row(
            children: [
              Expanded(
                  child: _tarifaChip(
                    'Taxi Ejecutivo',
                    d.precioBasicoTexto,
                    Icons.local_taxi_rounded,
                  )),
              const SizedBox(width: 12),
              Expanded(
                  child: _tarifaChip(
                    'SUV Premium',
                    d.precioPremiumTexto,
                    Icons.airport_shuttle_rounded,
                    isPremium: true,
                  )),
            ],
          ),

          const SizedBox(height: 16),

          // Botón confirmar
          GestureDetector(
            onTap: _confirmarDestino,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B6FF5), purpleMain],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: purpleMain.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  'Confirmar destino',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarifaChip(String label, String precio, IconData icon,
      {bool isPremium = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPremium ? const Color(0xFFF7F4FF) : purpleLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: purpleMid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: purpleMain, size: 20),
          const SizedBox(height: 6),
          Text(
            precio,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: purpleMain,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}