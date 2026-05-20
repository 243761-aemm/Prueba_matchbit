// lib/core/services/maps_service.dart
//
// Dependencias en pubspec.yaml:
//   google_maps_flutter: ^2.9.0
//   http: ^1.2.0
//   uuid: ^4.3.3   (para sessionToken)

import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

// ── Modelos ───────────────────────────────────────────────────────────────────

/// Sugerencia de lugar retornada por Places Autocomplete
class PlaceSuggestion {
  final String placeId;
  final String mainText;       // Ej: "Tuxtla Gutiérrez"
  final String secondaryText;  // Ej: "Chiapas, México"
  final String fullDescription;

  const PlaceSuggestion({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.fullDescription,
  });
}

/// Detalle completo de un lugar con coordenadas
class PlaceDetail {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double lat;
  final double lng;

  const PlaceDetail({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.lat,
    required this.lng,
  });
}

// ── Servicio ──────────────────────────────────────────────────────────────────

class MapsService {
  // Reemplaza con tu API Key de Google Cloud Console
  // Habilita: Maps SDK for Android/iOS, Places API, Geocoding API
  static const String _apiKey = 'AIzaSyA7A6G-ov-wqG7dluV75SZcrkHh91UnFVQ';

  // Origen fijo: Aeropuerto Ángel Albino Corzo (TGZ), Tuxtla Gutiérrez
  static const double _origenLat = 16.5636;
  static const double _origenLng = -93.0225;

  // Singleton
  MapsService._();
  static final MapsService instance = MapsService._();

  // ── Places Autocomplete ───────────────────────────────────────────────────
  /// Devuelve sugerencias mientras el usuario escribe su destino.
  /// [sessionToken] agrupa las llamadas en una sesión para reducir costos.
  Future<List<PlaceSuggestion>> autocomplete(
      String input, {
        String? sessionToken,
      }) async {
    if (input.trim().isEmpty) return [];

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': input,
        'key': _apiKey,
        'language': 'es',
        'components': 'country:mx',
        // Sesgo geográfico: radio de 300 km desde el aeropuerto
        'location': '$_origenLat,$_origenLng',
        'radius': '300000',
        if (sessionToken != null) 'sessiontoken': sessionToken,
      },
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return [];

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') return [];

      final predictions = data['predictions'] as List<dynamic>;
      return predictions.map((p) {
        final structured =
            p['structured_formatting'] as Map<String, dynamic>? ?? {};
        return PlaceSuggestion(
          placeId: p['place_id'] as String? ?? '',
          mainText: structured['main_text'] as String? ?? '',
          secondaryText: structured['secondary_text'] as String? ?? '',
          fullDescription: p['description'] as String? ?? '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Place Details ─────────────────────────────────────────────────────────
  /// Obtiene lat/lng y dirección formateada dado un place_id.
  /// Llama a esta función al seleccionar una sugerencia del autocomplete.
  Future<PlaceDetail?> getPlaceDetail(
      String placeId, {
        String? sessionToken,
      }) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'key': _apiKey,
        'language': 'es',
        'fields': 'name,formatted_address,geometry',
        if (sessionToken != null) 'sessiontoken': sessionToken,
      },
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') return null;

      final result = data['result'] as Map<String, dynamic>;
      final location = (result['geometry']
      as Map<String, dynamic>)['location'] as Map<String, dynamic>;

      return PlaceDetail(
        placeId: placeId,
        name: result['name'] as String? ?? '',
        formattedAddress: result['formatted_address'] as String? ?? '',
        lat: (location['lat'] as num).toDouble(),
        lng: (location['lng'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }

  // ── Reverse Geocoding (tap en el mapa) ────────────────────────────────────
  /// El usuario tocó el mapa → obtiene la dirección de ese punto.
  Future<PlaceDetail?> reverseGeocode(double lat, double lng) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '$lat,$lng',
        'key': _apiKey,
        'language': 'es',
      },
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') return null;

      final results = data['results'] as List<dynamic>;
      if (results.isEmpty) return null;

      final first = results.first as Map<String, dynamic>;
      return PlaceDetail(
        placeId: first['place_id'] as String? ?? '',
        name: first['formatted_address'] as String? ?? '',
        formattedAddress: first['formatted_address'] as String? ?? '',
        lat: lat,
        lng: lng,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Distancia Haversine ───────────────────────────────────────────────────
  /// Calcula la distancia en km entre el aeropuerto (origen) y el destino.
  double calcularDistanciaKm(double destLat, double destLng) {
    const double r = 6371.0;
    final double dLat = _toRad(destLat - _origenLat);
    final double dLng = _toRad(destLng - _origenLng);
    final double a = math.pow(math.sin(dLat / 2), 2).toDouble() +
        math.cos(_toRad(_origenLat)) *
            math.cos(_toRad(destLat)) *
            math.pow(math.sin(dLng / 2), 2);
    final double c = 2 * math.asin(math.sqrt(a));
    return r * c;
  }

  double _toRad(double deg) => deg * math.pi / 180.0;
}