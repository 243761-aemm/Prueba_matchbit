// lib/core/models/destination_model.dart

class DestinationModel {
  final String nombre;
  final String direccionCompleta;
  final double lat;
  final double lng;
  final double distanciaKm;
  final double tarifaBasica;
  final double tarifaPremium;
  final String placeId;

  const DestinationModel({
    required this.nombre,
    required this.direccionCompleta,
    required this.lat,
    required this.lng,
    required this.distanciaKm,
    required this.tarifaBasica,
    required this.tarifaPremium,
    required this.placeId,
  });

  String get kmTexto => distanciaKm < 1
      ? '${(distanciaKm * 1000).toStringAsFixed(0)} m'
      : '${distanciaKm.toStringAsFixed(0)} km';

  String get precioBasicoTexto =>
      '\$${tarifaBasica.toStringAsFixed(0)}';

  String get precioPremiumTexto =>
      '\$${tarifaPremium.toStringAsFixed(0)}';

  @override
  String toString() => 'DestinationModel($nombre, $lat, $lng)';
}