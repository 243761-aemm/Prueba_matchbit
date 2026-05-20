import 'package:flutter/material.dart';
import 'package:taxis/features/home/view/ClubDetailPage.dart';
import 'package:taxis/features/home/view/GymDetailPage.dart';

class ExplorarPage extends StatefulWidget {
  const ExplorarPage({super.key});

  @override
  State<ExplorarPage> createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  static const tealMain = Color(0xFF00C2A8);
  static const bgColor  = Color(0xFFF4F6F9);
  static const textDark = Color(0xFF1A1F36);

  String searchQuery        = '';
  int    _deporteSeleccionado = -1;
  String _filtroActivo      = 'Todo';

  final List<String> filtros = ['Todo', 'Tenis', 'Pádel', 'Fútbol', 'Gym'];

  final List<Map<String, dynamic>> deportes = [
    {'nombre': 'Pádel',    'emoji': '🏓'},
    {'nombre': 'Tenis',    'emoji': '🎾'},
    {'nombre': 'Fútbol',   'emoji': '⚽'},
    {'nombre': 'Básquet',  'emoji': '🏀'},
    {'nombre': 'Gimnasio', 'emoji': '🏋️'},
    {'nombre': 'Yoga',     'emoji': '🧘'},
    {'nombre': 'Natación', 'emoji': '🏊'},
    {'nombre': 'CrossFit', 'emoji': '🔥'},
  ];

  // isGym: true → abre GymDetailPage con los datos de gymData
  final List<Map<String, dynamic>> clubes = [
    {
      'nombre': 'Club Tenis Tuxtla',
      'ubicacion': 'Col. Centro',
      'distancia': '2.1 km',
      'rating': 4.9,
      'deportes': ['Tenis', 'Pádel'],
      'emojis': ['🎾', '🏓'],
      'color': const Color(0xFFD0EEFF),
      'emoji': '🎾',
      'isGym': false,
    },
    {
      'nombre': 'Futbol 5 Arena',
      'ubicacion': 'Col. Infonavit',
      'distancia': '1.4 km',
      'rating': 4.7,
      'deportes': ['Fútbol 5', 'Retas'],
      'emojis': ['⚽', '🏆'],
      'color': const Color(0xFFD4F5D4),
      'emoji': '⚽',
      'isGym': false,
    },
    {
      'nombre': 'Sport Center MX',
      'ubicacion': 'Col. Jardines',
      'distancia': '3.2 km',
      'rating': 4.6,
      'deportes': ['Pádel', 'Gimnasio'],
      'emojis': ['🏓', '🏋️'],
      'color': const Color(0xFFEDD9FF),
      'emoji': '🏓',
      'isGym': false,
    },
    {
      'nombre': 'Tennis Garden',
      'ubicacion': 'Colonia Centro',
      'distancia': '2.8 km',
      'rating': 4.7,
      'deportes': ['Tenis'],
      'emojis': ['🎾'],
      'color': const Color(0xFFFFD6E8),
      'emoji': '🎾',
      'isGym': false,
    },
    {
      'nombre': 'CrossFit Tuxtla',
      'ubicacion': 'Av. Central',
      'distancia': '1.9 km',
      'rating': 4.8,
      'deportes': ['CrossFit', 'Gimnasio'],
      'emojis': ['🔥', '🏋️'],
      'color': const Color(0xFFFFF3CC),
      'emoji': '🔥',
      'isGym': false,
    },
    // ── Gimnasio nuevo ──────────────────────────────────
    {
      'nombre': 'Iron Fitness Tuxtla',
      'ubicacion': 'Blvd. Belisario Domínguez',
      'distancia': '1.2 km',
      'rating': 4.9,
      'deportes': ['Gym', 'Funcional'],
      'emojis': ['🏋️', '💪'],
      'color': const Color(0xFFE8FAF7),
      'emoji': '🏋️',
      'isGym': true,
      // gymId debe coincidir con el id en gymData de GymDetailPage
      'gymId': 'gym1',
    },
  ];

  List<Map<String, dynamic>> get clubesFiltrados {
    return clubes.where((c) {
      final matchSearch = searchQuery.isEmpty ||
          (c['nombre'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      final matchFiltro = _filtroActivo == 'Todo' ||
          (c['deportes'] as List<String>)
              .any((d) => d.toLowerCase().contains(_filtroActivo.toLowerCase()));
      final matchDeporte = _deporteSeleccionado == -1 ||
          (c['deportes'] as List<String>).any((d) => d
              .toLowerCase()
              .contains(deportes[_deporteSeleccionado]['nombre']
              .toString()
              .toLowerCase()));
      return matchSearch && matchFiltro && matchDeporte;
    }).toList();
  }

  void _onTilePressed(Map<String, dynamic> c) {
    if (c['isGym'] == true) {
      // Busca el gym en gymData por id
      final gymData = _gymById(c['gymId'] as String);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GymDetailPage(gym: gymData)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ClubDetailPage(club: c)),
      );
    }
  }

  /// Obtiene el Map del gym desde la lista global gymData de GymDetailPage
  Map<String, dynamic> _gymById(String id) {
    return gymData.firstWhere(
          (g) => g['id'] == id,
      orElse: () => gymData.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildSearchBar(),
                  _buildFiltrosChip(),
                  _buildDeportesSection(),
                  _buildLocationBanner(),
                  _buildClubesList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: const Text(
        'Explorar clubes',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: textDark),
      ),
    );
  }

  // ── SEARCH ───────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        onChanged: (v) => setState(() => searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Buscar clubes...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: tealMain, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── FILTROS ──────────────────────────────────────────────
  Widget _buildFiltrosChip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filtros.length,
          itemBuilder: (_, i) {
            final activo = _filtroActivo == filtros[i];
            return GestureDetector(
              onTap: () => setState(() => _filtroActivo = filtros[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: activo ? tealMain : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: activo ? tealMain : Colors.grey.shade300),
                ),
                child: Text(
                  filtros[i],
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: activo ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── DEPORTES ─────────────────────────────────────────────
  Widget _buildDeportesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('Deportes',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textDark)),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: deportes.length,
            itemBuilder: (_, i) {
              final d        = deportes[i];
              final selected = _deporteSeleccionado == i;
              return GestureDetector(
                onTap: () => setState(() =>
                _deporteSeleccionado = selected ? -1 : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: selected ? tealMain : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? tealMain : Colors.grey.shade200,
                          width: selected ? 0 : 1.5,
                        ),
                        boxShadow: selected
                            ? [BoxShadow(color: tealMain.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Center(child: Text(d['emoji'], style: const TextStyle(fontSize: 26))),
                    ),
                    const SizedBox(height: 6),
                    Text(d['nombre'], style: TextStyle(
                      fontSize: 11,
                      color: selected ? tealMain : Colors.grey.shade600,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    )),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── LOCATION BANNER ──────────────────────────────────────
  Widget _buildLocationBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(children: [
        const Text('🗺️', style: TextStyle(fontSize: 32)),
        const SizedBox(height: 6),
        const Text('Tuxtla Gutiérrez, Chiapas',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textDark)),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.location_on_rounded, size: 13, color: tealMain),
          const SizedBox(width: 4),
          Text('${clubesFiltrados.length} clubes cerca de ti',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ]),
      ]),
    );
  }

  // ── LISTA ────────────────────────────────────────────────
  Widget _buildClubesList() {
    final lista = clubesFiltrados;
    if (lista.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text('No se encontraron clubes',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
        ),
      );
    }
    return Column(children: lista.map((c) => _clubTile(c)).toList());
  }

  // ── TILE ─────────────────────────────────────────────────
  Widget _clubTile(Map<String, dynamic> c) {
    final isGym = c['isGym'] == true;
    return GestureDetector(
      onTap: () => _onTilePressed(c),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          // Avatar
          Stack(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: c['color'] as Color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(c['emoji'], style: const TextStyle(fontSize: 26))),
            ),
            // Badge gym
            if (isGym)
              Positioned(
                right: -2, top: -2,
                child: Container(
                  width: 18, height: 18,
                  decoration: const BoxDecoration(
                    color: tealMain, shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.fitness_center_rounded,
                      color: Colors.white, size: 10),
                ),
              ),
          ]),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(c['nombre'], style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 14, color: textDark))),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_rounded, size: 12, color: tealMain),
                const SizedBox(width: 3),
                Text('${c['ubicacion']} · ${c['distancia']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ]),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                children: (c['deportes'] as List<String>)
                    .asMap()
                    .entries
                    .map((e) => _tag('${(c['emojis'] as List)[e.key]} ${e.value}'))
                    .toList(),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          // Rating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFC107)),
              const SizedBox(width: 3),
              Text('${c['rating']}', style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF8A6914))),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
    );
  }
}