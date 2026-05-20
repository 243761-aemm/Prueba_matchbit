import 'package:flutter/material.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  static const tealMain = Color(0xFF00C2A8);
  static const bgColor = Color(0xFFF4F6F9);
  static const textDark = Color(0xFF1A1F36);

  String _filtroActivo = 'Todos';

  final List<String> filtros = ['Todos', 'Torneos', 'Carreras', 'Ligas', 'Clases'];

  final List<Map<String, dynamic>> eventos = [
    {
      'fecha': '14',
      'mes': 'ABR',
      'nombre': 'Torneo Abierto de Pádel',
      'lugar': 'Club Tenis Tuxtla',
      'hora': '9:00 AM',
      'participantes': '16 participantes',
      'precio': 450,
      'disponibles': 3,
      'tipo': 'Torneos',
      'etiqueta': '3 lugares',
      'colorEtiqueta': Color(0xFF00C2A8),
    },
    {
      'fecha': '20',
      'mes': 'ABR',
      'nombre': 'Carrera 5K Naturaleza',
      'lugar': 'Parque Joyyo Mayu',
      'hora': '7:00 AM',
      'participantes': '200 inscritos',
      'precio': 150,
      'disponibles': 47,
      'tipo': 'Carreras',
      'etiqueta': '47 lugares',
      'colorEtiqueta': Color(0xFF00C2A8),
    },
    {
      'fecha': '27',
      'mes': 'ABR',
      'nombre': 'Liga Fútbol 5 Primavera',
      'lugar': 'Futbol 5 Arena',
      'hora': 'Todo el día',
      'participantes': '8 equipos',
      'precio': 800,
      'disponibles': 2,
      'tipo': 'Ligas',
      'etiqueta': '2 equipos',
      'colorEtiqueta': Color(0xFF00C2A8),
    },
    {
      'fecha': '3',
      'mes': 'MAY',
      'nombre': 'Torneo de Tenis Dobles',
      'lugar': 'Club Tenis Tuxtla',
      'hora': '10:00 AM',
      'participantes': null,
      'precio': 600,
      'disponibles': null,
      'tipo': 'Torneos',
      'etiqueta': 'Por pareja',
      'colorEtiqueta': Color(0xFF8A94A6),
    },
    {
      'fecha': '10',
      'mes': 'MAY',
      'nombre': 'Carrera 10K Chiapas',
      'lugar': 'Periférico Norte',
      'hora': '6:30 AM',
      'participantes': '500 inscritos',
      'precio': 250,
      'disponibles': null,
      'tipo': 'Carreras',
      'etiqueta': 'Incluye playera',
      'colorEtiqueta': Color(0xFF8A94A6),
    },
    {
      'fecha': '15',
      'mes': 'MAY',
      'nombre': 'Clínica de Yoga Avanzada',
      'lugar': 'Parque Central',
      'hora': '8:00 AM',
      'participantes': '20 inscritos',
      'precio': 0,
      'disponibles': 10,
      'tipo': 'Clases',
      'etiqueta': 'Gratis',
      'colorEtiqueta': Color(0xFF4CAF50),
    },
  ];

  List<Map<String, dynamic>> get eventosFiltrados {
    if (_filtroActivo == 'Todos') return eventos;
    return eventos.where((e) => e['tipo'] == _filtroActivo).toList();
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
                  _buildFiltros(),
                  const SizedBox(height: 8),
                  ...eventosFiltrados.map((e) => _eventoTile(e)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: const Text(
        'Eventos y torneos',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: textDark,
        ),
      ),
    );
  }

  Widget _buildFiltros() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: activo ? tealMain : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: activo ? tealMain : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  filtros[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

  Widget _eventoTile(Map<String, dynamic> e) {
    final esGratis = e['precio'] == 0;

    return GestureDetector(
      onTap: () {
        // Navegar al detalle del evento
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Fecha
            Container(
              width: 50,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [tealMain, Color(0xFF009E88)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    e['mes'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    e['fecha'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e['nombre'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 12, color: tealMain),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${e['lugar']} · ${e['hora']}${e['participantes'] != null ? ' · ${e['participantes']}' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Precio + etiqueta
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  esGratis ? 'Gratis' : '\$${e['precio']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: esGratis ? const Color(0xFF4CAF50) : tealMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e['etiqueta'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: e['colorEtiqueta'] as Color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}