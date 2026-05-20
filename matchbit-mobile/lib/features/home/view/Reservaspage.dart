import 'package:flutter/material.dart';

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});

  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage>
    with SingleTickerProviderStateMixin {
  static const tealMain = Color(0xFF00C2A8);
  static const bgColor = Color(0xFFF4F6F9);
  static const textDark = Color(0xFF1A1F36);

  late TabController _tabController;

  final _proximasReservas = [
    {
      'tipo': 'torneo',
      'nombre': 'Torneo Abierto de Pádel',
      'club': 'Club Tenis Tuxtla',
      'fecha': '14 Abr, 2025',
      'hora': '9:00 AM',
      'precio': 495,
      'codigo': '4821',
      'estado': 'confirmada',
      'emoji': '🏓',
      'color': const Color(0xFFD4F5E2),
    },
    {
      'tipo': 'cancha',
      'nombre': 'Cancha A1 - Tenis',
      'club': 'Tennis Garden',
      'fecha': '18 Abr, 2025',
      'hora': '10:00 AM',
      'precio': 150,
      'codigo': '3357',
      'estado': 'confirmada',
      'emoji': '🎾',
      'color': const Color(0xFFD0EEFF),
    },
    {
      'tipo': 'gym',
      'nombre': 'Plan Día — Acceso completo',
      'club': 'Iron Fitness Tuxtla',
      'fecha': '16 Abr, 2025',
      'hora': '07:00 AM',
      'precio': 88,
      'codigo': '2241',
      'estado': 'confirmada',
      'emoji': '🏋️',
      'color': const Color(0xFFE8FAF7),
    },
  ];

  final _historialReservas = [
    {
      'tipo': 'cancha',
      'nombre': 'Cancha A1 - Tenis',
      'club': 'Club Tenis Tuxtla',
      'fecha': '1 Abr, 2025',
      'hora': '9:00 AM - 10:00 AM',
      'precio': 275,
      'codigo': '9921',
      'estado': 'completada',
      'emoji': '🎾',
      'color': const Color(0xFFD0EEFF),
    },
    {
      'tipo': 'gym',
      'nombre': 'Plan Semana — 7 días',
      'club': 'Funcional Box Gym',
      'fecha': '25 Mar, 2025',
      'hora': '06:00 AM',
      'precio': 308,
      'codigo': '8872',
      'estado': 'completada',
      'emoji': '🔥',
      'color': const Color(0xFFFFF3CC),
    },
    {
      'tipo': 'torneo',
      'nombre': 'Liga Pádel Primavera',
      'club': 'Sport Center MX',
      'fecha': '22 Mar, 2025',
      'hora': '10:00 AM',
      'precio': 350,
      'codigo': '7714',
      'estado': 'completada',
      'emoji': '🏓',
      'color': const Color(0xFFD4F5E2),
    },
    {
      'tipo': 'cancha',
      'nombre': 'Cancha Fútbol 7',
      'club': 'Cancha Fútbol 7',
      'fecha': '10 Mar, 2025',
      'hora': '7:00 PM - 8:00 PM',
      'precio': 600,
      'codigo': '5543',
      'estado': 'cancelada',
      'emoji': '⚽',
      'color': const Color(0xFFFFF3CC),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _header(),
          _tabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _listaReservas(_proximasReservas),
                _listaReservas(_historialReservas),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────
  Widget _header() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 14,
        16,
        14,
      ),
      child: const Row(
        children: [
          Text(
            'Mis reservaciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  // ── TABS ─────────────────────────────────────────────────
  Widget _tabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: tealMain,
        unselectedLabelColor: Colors.grey.shade400,
        indicatorColor: tealMain,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: 'Próximas'),
          Tab(text: 'Historial'),
        ],
      ),
    );
  }

  // ── LISTA ────────────────────────────────────────────────
  Widget _listaReservas(List<Map<String, dynamic>> lista) {
    if (lista.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📋', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'Sin reservaciones',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: textDark,
              ),
            ),
            Text(
              'Aquí aparecerán tus reservas',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: lista.length,
      itemBuilder: (_, i) => _reservaCard(lista[i]),
    );
  }

  // ── CARD ─────────────────────────────────────────────────
  Widget _reservaCard(Map<String, dynamic> r) {
    final estado = r['estado'] as String;
    final estadoColor = estado == 'confirmada'
        ? const Color(0xFF00C875)
        : estado == 'completada'
        ? Colors.grey.shade500
        : const Color(0xFFFF5252);
    final estadoLabel = estado == 'confirmada'
        ? 'Confirmada'
        : estado == 'completada'
        ? 'Completada'
        : 'Cancelada';
    final esTorneo = r['tipo'] == 'torneo';
    final esGym    = r['tipo'] == 'gym';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Parte superior con color
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(18)),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (r['color'] as Color),
                    (r['color'] as Color).withOpacity(0.5),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(r['emoji'],
                          style: const TextStyle(fontSize: 44)),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: esTorneo
                            ? tealMain.withOpacity(0.85)
                            : esGym
                            ? const Color(0xFF5C6BC0).withOpacity(0.85)
                            : Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        esTorneo ? 'Torneo' : esGym ? 'Gimnasio' : 'Cancha',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: estadoColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: estadoColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        estadoLabel,
                        style: TextStyle(
                          color: estadoColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r['nombre'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 12, color: Color(0xFF8A94A6)),
                    const SizedBox(width: 4),
                    Text(
                      r['club'],
                      style: const TextStyle(
                          color: Color(0xFF8A94A6), fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _infoChip(Icons.calendar_today_rounded, r['fecha']),
                    const SizedBox(width: 8),
                    _infoChip(Icons.access_time_rounded, r['hora']),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total pagado',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8A94A6),
                          ),
                        ),
                        Text(
                          '\$${r['precio']}.00 MXN',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    // Código de acceso
                    if (estado == 'confirmada')
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: tealMain.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: tealMain.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.qr_code_rounded,
                                  color: tealMain, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                r['codigo'],
                                style: const TextStyle(
                                  color: tealMain,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (estado != 'confirmada')
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Ver detalles',
                          style: TextStyle(
                            color: tealMain,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF8A94A6)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8A94A6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}