import 'package:flutter/material.dart';
import 'package:taxis/core/user_session.dart';
import 'package:taxis/features/home/view/ClubDetailPage.dart';
import 'package:taxis/features/home/view/Reservaspage.dart';
import 'package:taxis/features/home/view/Torneodetailpage.dart';
import 'package:taxis/features/home/view/explorarPage.dart';
import 'package:taxis/features/home/view/eventosPage.dart';
import 'package:taxis/features/home/view/comunidadPage.dart';
import 'package:taxis/features/home/view/perfilPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 0;
  String searchQuery = '';
  int _deporteSeleccionado = -1;

  static const tealMain = Color(0xFF00C2A8);
  static const bgColor = Color(0xFFF4F6F9);
  static const textDark = Color(0xFF1A1F36);

  final List<Map<String, dynamic>> deportes = [
    {'nombre': 'Pádel', 'emoji': '🏓'},
    {'nombre': 'Tenis', 'emoji': '🎾'},
    {'nombre': 'Fútbol', 'emoji': '⚽'},
    {'nombre': 'Básquet', 'emoji': '🏀'},
    {'nombre': 'Gimnasio', 'emoji': '🏋️'},
    {'nombre': 'Yoga', 'emoji': '🧘'},
    {'nombre': 'Natación', 'emoji': '🏊'},
    {'nombre': 'CrossFit', 'emoji': '🔥'},
  ];

  final List<Map<String, dynamic>> canchas = [
    {'nombre': 'Club de Pádel Elite', 'ubicacion': 'Col. Patria Nueva', 'precio': 180, 'rating': 4.9, 'turnos': 8, 'color': Color(0xFFD4F5E2), 'emoji': '🏓', 'tipo': 'Pádel'},
    {'nombre': 'Tennis Garden', 'ubicacion': 'Colonia Centro', 'precio': 150, 'rating': 4.7, 'turnos': 5, 'color': Color(0xFFD0EEFF), 'emoji': '🎾', 'tipo': 'Tenis'},
    {'nombre': 'Cancha Fútbol 7', 'ubicacion': 'Libramiento Norte', 'precio': 600, 'rating': 4.8, 'turnos': 3, 'color': Color(0xFFFFF3CC), 'emoji': '⚽', 'tipo': 'Fútbol'},
    {'nombre': 'Sport Center MX', 'ubicacion': 'Col. Jardines', 'precio': 160, 'rating': 4.6, 'turnos': 12, 'color': Color(0xFFEDD9FF), 'emoji': '🏓', 'tipo': 'Pádel'},
    {'nombre': 'Cancha Pro Tenis', 'ubicacion': 'Av. Central', 'precio': 130, 'rating': 4.5, 'turnos': 0, 'color': Color(0xFFFFD6E8), 'emoji': '🎾', 'tipo': 'Tenis'},
    {'nombre': 'Futbolito Express', 'ubicacion': 'Blvd. Comitán', 'precio': 500, 'rating': 4.9, 'turnos': 6, 'color': Color(0xFFD4F5D4), 'emoji': '⚽', 'tipo': 'Fútbol'},
  ];

  final List<Map<String, dynamic>> torneos = [
    {
      'fecha': '14',
      'mes': 'ABR',
      'nombre': 'Torneo Abierto de Pádel',
      'deporte': 'Pádel',
      'emoji': '🏓',
      'tipo': 'Torneo',
      'precio': 450,
      'lugares': 16,
      'inscritos': 13,
      'club': 'Club Tenis Tuxtla',
      'hora': '9:00 AM',
      'descripcion': 'Torneo de pádel categoría mixta abierto a todos los niveles. Formato de eliminación directa. Incluye: agua, snacks, medalla para los 3 primeros lugares y premio en efectivo para el campeón.',
      'premios': [2000, 1000, 500],
      'colorGrad': [Color(0xFF1A1F3C), Color(0xFF0D1B2A)],
    },
    {
      'fecha': '18',
      'mes': 'ABR',
      'nombre': 'Clínica de Tenis para Adultos',
      'deporte': 'Tenis',
      'emoji': '🎾',
      'tipo': 'Clínica',
      'precio': 200,
      'lugares': 12,
      'inscritos': 7,
      'club': 'Tennis Garden',
      'hora': '10:00 AM',
      'descripcion': 'Clínica intensiva de tenis para adultos de todos los niveles. Incluye análisis de técnica, ejercicios de saque y volea, y partidos de práctica.',
      'premios': [],
      'colorGrad': [Color(0xFF0D2137), Color(0xFF0A1628)],
    },
    {
      'fecha': '25',
      'mes': 'ABR',
      'nombre': 'Torneo Fútbol 7 Empresarial',
      'deporte': 'Fútbol',
      'emoji': '⚽',
      'tipo': 'Torneo',
      'precio': 2000,
      'lugares': 16,
      'inscritos': 10,
      'club': 'Cancha Fútbol 7',
      'hora': '8:00 AM',
      'descripcion': 'Torneo empresarial de fútbol 7. Inscripción por equipo. Trofeo para el campeón y subcampeón. Árbitros profesionales, hidratación incluida.',
      'premios': [5000, 2500, 1000],
      'colorGrad': [Color(0xFF1A2410), Color(0xFF0E1A0A)],
    },
    {
      'fecha': '2',
      'mes': 'MAY',
      'nombre': 'Yoga en el Parque',
      'deporte': 'Yoga',
      'emoji': '🧘',
      'tipo': 'Clase',
      'precio': 0,
      'lugares': 30,
      'inscritos': 18,
      'club': 'Parque Central',
      'hora': '7:00 AM',
      'descripcion': 'Clase de yoga al aire libre para todos los niveles. Lleva tu tapete. Duración 90 minutos. Incluye meditación guiada al finalizar.',
      'premios': [],
      'colorGrad': [Color(0xFF1A1030), Color(0xFF0D0A20)],
    },
    {
      'fecha': '10',
      'mes': 'MAY',
      'nombre': 'Carrera 5K Ciudad Verde',
      'deporte': 'Running',
      'emoji': '🏃',
      'tipo': 'Carrera',
      'precio': 150,
      'lugares': 200,
      'inscritos': 142,
      'club': 'Parque El Cedro',
      'hora': '6:30 AM',
      'descripcion': 'Carrera urbana de 5 kilómetros por las calles de Tuxtla. Chip de cronometraje, hidratación en ruta y medalla finisher para todos los participantes.',
      'premios': [1500, 800, 400],
      'colorGrad': [Color(0xFF2A1000), Color(0xFF1A0A00)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            _homeBody(),
            ExplorarPage(),
            EventosPage(),
            ComunidadPage(),
            PerfilPage(),
          ],
        ),
      ),
    );
  }

  Widget _homeBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _searchBar(),
              _deportesSection(),
              _canchasSection(),
              _torneosSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _explorarBody() {
    return const Center(child: Text('Explorar'));
  }

  Widget _perfilBody() {
    return const Center(child: Text('Perfil'));
  }

  // ── HEADER ────────────────────────────────────────────────
  Widget _header() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [tealMain, Color(0xFF00A693)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.sports_tennis_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'MatchBit',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 19,
                color: textDark,
                letterSpacing: -0.5,
              ),
            ),
          ]),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: textDark, size: 20),
                  ),
                  Positioned(
                    right: 12,
                    top: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5252),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => currentIndex = 1),
                child: CircleAvatar(
                  backgroundColor: tealMain.withOpacity(0.15),
                  radius: 18,
                  child: Text(
                    UserSession().inicial,
                    style: const TextStyle(
                      color: tealMain,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ───────────────────────────────────────────
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: tealMain, size: 14),
              const SizedBox(width: 4),
              Text(
                'Tuxtla Gutiérrez, Chis.',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: const TextSpan(children: [
              TextSpan(
                text: '¿Qué deporte\n',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: 'jugamos hoy?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: tealMain,
                  height: 1.1,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Buscar canchas, clubs, torneos...',
              hintStyle:
              TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon:
              Icon(Icons.search_rounded, color: Colors.grey.shade400),
              suffixIcon: Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: tealMain,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: Colors.white, size: 18),
              ),
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
        ],
      ),
    );
  }

  // ── DEPORTES ─────────────────────────────────────────────
  Widget _deportesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'Deportes',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: textDark,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: deportes.length,
            itemBuilder: (_, i) {
              final d = deportes[i];
              final selected = _deporteSeleccionado == i;
              return GestureDetector(
                onTap: () => setState(() {
                  _deporteSeleccionado = selected ? -1 : i;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: selected ? tealMain : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? tealMain : Colors.grey.shade200,
                          width: selected ? 0 : 1.5,
                        ),
                        boxShadow: selected
                            ? [
                          BoxShadow(
                            color: tealMain.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                            : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(d['emoji'],
                            style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      d['nombre'],
                      style: TextStyle(
                        fontSize: 11,
                        color: selected ? tealMain : Colors.grey.shade600,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── CANCHAS DESTACADAS ───────────────────────────────────
  Widget _canchasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lugares destacados',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: textDark,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => currentIndex = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: tealMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Ver todo',
                    style: TextStyle(
                      color: tealMain,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 236,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: canchas.length,
            itemBuilder: (_, i) {
              final c = canchas[i];
              final sinDisp = c['turnos'] == 0;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ClubDetailPage(club: c)),
                ),
                child: Container(
                  width: 195,
                  margin: const EdgeInsets.only(right: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parte superior con color
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (c['color'] as Color),
                                (c['color'] as Color).withOpacity(0.5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Emoji grande
                              Positioned(
                                right: 12,
                                bottom: 8,
                                child: Text(c['emoji'],
                                    style: const TextStyle(fontSize: 42)),
                              ),
                              // Badge disponibilidad
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: sinDisp
                                        ? const Color(0xFFFF5252)
                                        : const Color(0xFF00C875),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    sinDisp
                                        ? 'No disponible'
                                        : '${c['turnos']} turnos',
                                    style: const TextStyle(
                                      color: Colors.white,
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
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c['tipo'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade400,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              c['nombre'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded,
                                    size: 12,
                                    color: Colors.grey.shade400),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    c['ubicacion'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${c['precio']}/hr',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: textDark,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF8E1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          size: 12,
                                          color: Color(0xFFFFC107)),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${c['rating']}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF8A6914),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── PRÓXIMOS TORNEOS ─────────────────────────────────────
  Widget _torneosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Próximos torneos',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: textDark,
                    ),
                  ),
                  Text(
                    'Eventos cerca de ti',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A94A6),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tealMain.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Ver todo',
                  style: TextStyle(
                    color: tealMain,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...torneos.map((t) => _torneoTile(t)),
      ],
    );
  }

  Widget _torneoTile(Map<String, dynamic> t) {
    final esGratis = t['precio'] == 0;
    final lleno =
        (t['inscritos'] as int) >= (t['lugares'] as int);
    final pct =
        (t['inscritos'] as int) / (t['lugares'] as int);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TorneoDetailPage(torneo: t),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fecha
                  Container(
                    width: 52,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [tealMain, const Color(0xFF009E88)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t['mes'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          t['fecha'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t['nombre'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                size: 12, color: Color(0xFF8A94A6)),
                            const SizedBox(width: 4),
                            Text(
                              t['hora'],
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF8A94A6)),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on_rounded,
                                size: 12, color: Color(0xFF8A94A6)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                t['club'],
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF8A94A6)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: [
                            _tag(t['deporte'],
                                color: tealMain.withOpacity(0.1),
                                textColor: tealMain),
                            _tag(t['tipo']),
                            _tag(
                              esGratis ? 'Gratis' : '\$${t['precio']}',
                              color: esGratis
                                  ? Colors.green.shade50
                                  : const Color(0xFFFFF3E0),
                              textColor: esGratis
                                  ? Colors.green.shade700
                                  : const Color(0xFFE65100),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Emoji
                  Text(t['emoji'],
                      style: const TextStyle(fontSize: 28)),
                ],
              ),
            ),
            // Barra de progreso
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18)),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: const Color(0xFFF0F0F0),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${t['inscritos']}/${t['lugares']} inscritos',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8A94A6),
                              ),
                            ),
                            Text(
                              lleno
                                  ? 'Sin lugares'
                                  : '${t['lugares'] - t['inscritos'] as int} disponibles',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: lleno
                                    ? const Color(0xFFFF5252)
                                    : tealMain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: pct,
                            backgroundColor: const Color(0xFFF0F0F0),
                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                              lleno
                                  ? const Color(0xFFFF5252)
                                  : tealMain,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.grey.shade600,
        ),
      ),
    );
  }

  // ── BOTTOM NAV ───────────────────────────────────────────
  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        selectedItemColor: tealMain,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
// 3. Corrige el BottomNavigationBar — el ícono de Eventos está mal
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded), label: 'Explorar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded),
              label: 'Eventos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_rounded),
              label: 'Comunidad'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}