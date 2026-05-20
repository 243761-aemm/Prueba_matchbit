// lib/core/services/tarifa_service.dart
//
// Microservicio de tarifas local.
// En producción, reemplaza _calcularLocal() con una llamada HTTP a tu backend.

import '../models/destination_model.dart';
import 'maps_service.dart' show MapsService;

/// Resultado de la consulta de tarifa
class TarifaResult {
  final double distanciaKm;
  final double tarifaBasica;   // Taxi Ejecutivo (sedán)
  final double tarifaPremium;  // SUV Premium
  final bool exito;
  final String? error;

  const TarifaResult({
    required this.distanciaKm,
    required this.tarifaBasica,
    required this.tarifaPremium,
    required this.exito,
    this.error,
  });

  factory TarifaResult.error(String mensaje) => TarifaResult(
    distanciaKm: 0,
    tarifaBasica: 0,
    tarifaPremium: 0,
    exito: false,
    error: mensaje,
  );
}

class TarifaService {
  TarifaService._();
  static final TarifaService instance = TarifaService._();

  // ── Parámetros de tarificación ────────────────────────────────────────────
  // Ajusta estos valores según tu estructura de precios real.

  // Tarifa base (banderazo) en MXN
  static const double _banderazoBasico   = 80.0;
  static const double _banderazoPremium  = 120.0;

  // Costo por km adicional
  static const double _precioPorKmBasico   = 9.5;
  static const double _precioPorKmPremium  = 14.0;

  // Tarifa mínima
  static const double _minimoBasico   = 180.0;
  static const double _minimoPremium  = 280.0;

  // Recargo por distancia larga (> 100 km)
  static const double _recargoLargoBasico   = 0.08; // 8%
  static const double _recargoLargoPremium  = 0.05; // 5%

  // ── API pública ───────────────────────────────────────────────────────────

  /// Calcula la tarifa para un destino dado su lat/lng.
  /// En producción, sustituye el cuerpo por una llamada HTTP a tu microservicio:
  ///
  ///   POST https://tu-backend.com/tarifas
  ///   { "lat": destLat, "lng": destLng }
  ///   → { "distanciaKm": 85.3, "tarifaBasica": 640, "tarifaPremium": 1100 }
  ///
  Future<TarifaResult> calcularTarifa(double destLat, double destLng) async {
    try {
      // 1. Calcula distancia con Haversine (o usa tu API de distancias)
      final km = MapsService.instance.calcularDistanciaKm(destLat, destLng);

      // 2. Calcula tarifas localmente (reemplaza con llamada HTTP en prod)
      return _calcularLocal(km);
    } catch (e) {
      return TarifaResult.error('No se pudo calcular la tarifa: $e');
    }
  }

  /// Construye un [DestinationModel] completo dado un PlaceDetail.
  Future<DestinationModel> construirDestino({
    required String nombre,
    required String direccionCompleta,
    required String placeId,
    required double lat,
    required double lng,
  }) async {
    final tarifa = await calcularTarifa(lat, lng);
    return DestinationModel(
      nombre: nombre,
      direccionCompleta: direccionCompleta,
      lat: lat,
      lng: lng,
      distanciaKm: tarifa.distanciaKm,
      tarifaBasica: tarifa.tarifaBasica,
      tarifaPremium: tarifa.tarifaPremium,
      placeId: placeId,
    );
  }

  // ── Lógica interna ────────────────────────────────────────────────────────
  TarifaResult _calcularLocal(double km) {
    double basico  = _banderazoBasico  + km * _precioPorKmBasico;
    double premium = _banderazoPremium + km * _precioPorKmPremium;

    // Recargo para viajes largos
    if (km > 100) {
      basico  *= (1 + _recargoLargoBasico);
      premium *= (1 + _recargoLargoPremium);
    }

    // Aplica mínimos
    basico  = basico  < _minimoBasico   ? _minimoBasico   : basico;
    premium = premium < _minimoPremium  ? _minimoPremium  : premium;

    // Redondea a decenas (precios más amigables)
    basico  = (basico  / 10).ceil() * 10.0;
    premium = (premium / 10).ceil() * 10.0;

    return TarifaResult(
      distanciaKm: double.parse(km.toStringAsFixed(1)),
      tarifaBasica: basico,
      tarifaPremium: premium,
      exito: true,
    );
  }
}