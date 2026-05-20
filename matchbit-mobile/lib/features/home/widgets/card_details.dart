import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  final Map<String, dynamic> evento;

  const CardDetails({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    final esGratis = evento['precio'] == 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _eventoHeader(evento),

          // ── CONTENIDO ──
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _detalleFila(Icons.place, "Lugar", evento['lugar'] ?? "Por definir"),
                _detalleFila(Icons.timer, "Duración", evento['duracion'] ?? "1 día"),
                _detalleFila(Icons.sports_tennis, "Nivel", evento['nivel'] ?? "Todos"),
                _detalleFila(Icons.people, "Lugares disp.", "${evento['lugares']} disponibles"),
                _detalleFila(Icons.attach_money, "Inscripción",
                    esGratis ? "Gratis" : "\$${evento['precio']} MXN"),

                const SizedBox(height: 20),

                // Sobre el evento
                const Text(
                  "SOBRE EL EVENTO",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  evento['descripcion'] ??
                      "Este es un evento deportivo con categorías masculino, femenino y mixto.",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),

                const SizedBox(height: 20),


                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // Lógica de inscripción
                    },
                    child: Text(
                      esGratis
                          ? "Inscribirse - Gratis"
                          : "Inscribirse - \$${evento['precio']} MXN →",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER CON GRADIENTE ──
  Widget _eventoHeader(Map<String, dynamic> evento) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00C2A8), Color(0xFF0078D7)], // verde → azul
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            evento['tipo'].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            evento['nombre'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "sábado, ${evento['fecha']} de ${evento['mes']} de 2026",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── DETALLE FILA ESTILO TABLA ──
  Widget _detalleFila(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icono, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: titulo == "Inscripción" ? Colors.green : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}