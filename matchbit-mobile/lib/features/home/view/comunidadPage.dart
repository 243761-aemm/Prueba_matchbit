import 'package:flutter/material.dart';

class ComunidadPage extends StatefulWidget {
  const ComunidadPage({super.key});

  @override
  State<ComunidadPage> createState() => _ComunidadPageState();
}

class _ComunidadPageState extends State<ComunidadPage> {
  static const tealMain = Color(0xFF00C2A8);
  static const bgColor = Color(0xFFF4F6F9);
  static const textDark = Color(0xFF1A1F36);

  String _tabActivo = 'Feed';
  final List<String> tabs = ['Feed', 'Retas', 'Ranking', 'Partners'];

  final List<Map<String, dynamic>> posts = [
    {
      'iniciales': 'CM',
      'nombre': 'Carlos Mendez',
      'tiempo': 'Hace 2 horas',
      'deporte': 'Tenis',
      'emoji': '🎾',
      'nivel': 'Intermedio',
      'texto':
      '¡Increíble partido hoy en Club Tenis Tuxtla! Ganamos el set 6-3 💪 Buscamos rivales para el próximo sábado. ¿Alguien se apunta?',
      'likes': 24,
      'comentarios': 8,
      'estaReta': false,
    },
    {
      'esReta': true,
      'titulo': '30 minutos de cardio 🔥',
      'descripcion': 'Comparte tu sesión y acumula puntos matchbit',
      'completaron': 47,
      'vence': 'Vence en 4h',
    },
    {
      'iniciales': 'LA',
      'nombre': 'Luisa Arreola',
      'tiempo': 'Hace 5 horas',
      'deporte': 'Running',
      'emoji': '🏃',
      'nivel': null,
      'texto':
      '¡Me inscribí a la Carrera 5K del 20 de abril! ¿Alguien más va? Hacemos un grupo de entrenamiento 🏃',
      'likes': 15,
      'comentarios': 12,
      'estaReta': false,
    },
    {
      'iniciales': 'MR',
      'nombre': 'Miguel Ruiz',
      'tiempo': 'Hace 1 día',
      'deporte': 'Pádel',
      'emoji': '🏓',
      'nivel': 'Avanzado',
      'texto':
      'Buscando pareja para el Torneo Abierto de Pádel del 14 de abril. Nivel avanzado. ¡Escríbeme! 🏓',
      'likes': 31,
      'comentarios': 5,
      'estaReta': false,
    },
  ];

  final List<Map<String, dynamic>> retas = [
    {
      'titulo': '30 minutos de cardio 🔥',
      'descripcion': 'Comparte tu sesión y acumula puntos matchbit',
      'completaron': 47,
      'vence': 'Vence en 4h',
      'aceptada': false,
    },
    {
      'titulo': 'Juega 3 sets esta semana 🎾',
      'descripcion': 'Reserva y completa 3 sets en cualquier cancha de tenis',
      'completaron': 23,
      'vence': 'Vence en 2 días',
      'aceptada': true,
    },
    {
      'titulo': 'Primer torneo del mes 🏆',
      'descripcion': 'Inscríbete a cualquier torneo de abril',
      'completaron': 89,
      'vence': 'Vence en 5 días',
      'aceptada': false,
    },
  ];

  final List<Map<String, dynamic>> ranking = [
    {'pos': 1, 'iniciales': 'MR', 'nombre': 'Miguel Ruiz', 'puntos': 1240, 'deporte': 'Pádel'},
    {'pos': 2, 'iniciales': 'CM', 'nombre': 'Carlos Mendez', 'puntos': 980, 'deporte': 'Tenis'},
    {'pos': 3, 'iniciales': 'LA', 'nombre': 'Luisa Arreola', 'puntos': 870, 'deporte': 'Running'},
    {'pos': 4, 'iniciales': 'JP', 'nombre': 'Jorge Pérez', 'puntos': 740, 'deporte': 'Fútbol'},
    {'pos': 5, 'iniciales': 'SG', 'nombre': 'Sofía García', 'puntos': 690, 'deporte': 'Yoga'},
  ];

  final List<Map<String, dynamic>> partners = [
    {'iniciales': 'MR', 'nombre': 'Miguel Ruiz', 'deporte': 'Pádel', 'nivel': 'Avanzado', 'distancia': '1.2 km'},
    {'iniciales': 'SG', 'nombre': 'Sofía García', 'deporte': 'Tenis', 'nivel': 'Intermedio', 'distancia': '2.4 km'},
    {'iniciales': 'JP', 'nombre': 'Jorge Pérez', 'deporte': 'Fútbol', 'nivel': 'Principiante', 'distancia': '0.8 km'},
    {'iniciales': 'AL', 'nombre': 'Ana López', 'deporte': 'Running', 'nivel': 'Intermedio', 'distancia': '3.1 km'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: const Row(
        children: [
          Text(
            'Comunidad ',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: textDark,
            ),
          ),
          Text('🏅', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          itemBuilder: (_, i) {
            final activo = _tabActivo == tabs[i];
            return GestureDetector(
              onTap: () => setState(() => _tabActivo = tabs[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: activo ? tealMain : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: activo ? tealMain : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  tabs[i],
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

  Widget _buildBody() {
    switch (_tabActivo) {
      case 'Feed':
        return _buildFeed();
      case 'Retas':
        return _buildRetas();
      case 'Ranking':
        return _buildRanking();
      case 'Partners':
        return _buildPartners();
      default:
        return _buildFeed();
    }
  }

  // ── FEED ──────────────────────────────────────────────────
  Widget _buildFeed() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: posts.length,
      itemBuilder: (_, i) {
        final p = posts[i];
        if (p['esReta'] == true) return _retaCard(p);
        return _postCard(p);
      },
    );
  }

  Widget _postCard(Map<String, dynamic> p) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera usuario
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: tealMain.withOpacity(0.15),
                child: Text(
                  p['iniciales'],
                  style: const TextStyle(
                    color: tealMain,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['nombre'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: textDark,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          p['tiempo'],
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                        const SizedBox(width: 6),
                        Text('·', style: TextStyle(color: Colors.grey.shade400)),
                        const SizedBox(width: 6),
                        Text(
                          '${p['emoji']} ${p['deporte']}',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (p['nivel'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tealMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    p['nivel'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: tealMain,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            p['texto'],
            style: const TextStyle(fontSize: 13, color: textDark, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _accionBtn(Icons.favorite_border_rounded, '${p['likes']}'),
              const SizedBox(width: 16),
              _accionBtn(Icons.chat_bubble_outline_rounded,
                  '${p['comentarios']} comentarios'),
              const SizedBox(width: 16),
              _accionBtn(Icons.link_rounded, 'Compartir'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accionBtn(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _retaCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text('⚡', style: TextStyle(fontSize: 11)),
                    SizedBox(width: 4),
                    Text(
                      'Reta del día',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                r['vence'],
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            r['titulo'],
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            r['descripcion'],
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people_rounded,
                      size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    '${r['completaron']} personas completaron',
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: tealMain,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Aceptar reto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

  // ── RETAS ──────────────────────────────────────────────────
  Widget _buildRetas() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: retas.length,
      itemBuilder: (_, i) {
        final r = retas[i];
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: r['aceptada'] == true
                ? Border.all(color: tealMain.withOpacity(0.4))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r['titulo'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: textDark),
                  ),
                  Text(r['vence'],
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 4),
              Text(r['descripcion'],
                  style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_rounded,
                          size: 14, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        '${r['completaron']} completaron',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: r['aceptada'] == true
                          ? Colors.grey.shade100
                          : tealMain,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      r['aceptada'] == true ? 'En progreso' : 'Aceptar',
                      style: TextStyle(
                        color: r['aceptada'] == true
                            ? Colors.grey.shade500
                            : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── RANKING ────────────────────────────────────────────────
  Widget _buildRanking() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: ranking.length,
      itemBuilder: (_, i) {
        final r = ranking[i];
        final esPodio = r['pos'] <= 3;
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(14),
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
            children: [
              // Posición
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: esPodio
                      ? [
                    const Color(0xFFFFD700),
                    const Color(0xFFC0C0C0),
                    const Color(0xFFCD7F32),
                  ][r['pos'] - 1]
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${r['pos']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: esPodio ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: tealMain.withOpacity(0.15),
                child: Text(
                  r['iniciales'],
                  style: const TextStyle(
                    color: tealMain,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['nombre'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: textDark,
                      ),
                    ),
                    Text(
                      r['deporte'],
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Text(
                '${r['puntos']} pts',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: tealMain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── PARTNERS ───────────────────────────────────────────────
  Widget _buildPartners() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: partners.length,
      itemBuilder: (_, i) {
        final p = partners[i];
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(14),
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
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: tealMain.withOpacity(0.15),
                child: Text(
                  p['iniciales'],
                  style: const TextStyle(
                    color: tealMain,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['nombre'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _chip(p['deporte'], tealMain.withOpacity(0.1), tealMain),
                        const SizedBox(width: 6),
                        _chip(p['nivel'], Colors.grey.shade100,
                            Colors.grey.shade600),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 2),
                      Text(
                        p['distancia'],
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: tealMain,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Retar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}