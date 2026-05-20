class RatingModel {
  final String viajeId;       // código del viaje (APEX-XXXX)
  final int estrellaViaje;    // 1-5
  final int estrellaConductor; // 1-5
  final List<String> destacados; // tags seleccionados
  final String observaciones;
  final DateTime fecha;

  const RatingModel({
    required this.viajeId,
    required this.estrellaViaje,
    required this.estrellaConductor,
    required this.destacados,
    required this.observaciones,
    required this.fecha,
  });
}