import 'package:flutter/material.dart';
import 'package:taxis/features/home/view/Pagogympage.dart';

// ─────────────────────────────────────────────────────────
// Datos de gimnasios (en producción vendrían del backend)
// ─────────────────────────────────────────────────────────
final List<Map<String, dynamic>> gymData = [
  {
    'id': 'gym1',
    'nombre': 'Iron Fitness Tuxtla',
    'ubicacion': 'Col. Centro, Tuxtla Gutiérrez',
    'direccion': 'Blvd. Belisario Domínguez #1240',
    'horario': '5am – 11pm',
    'rating': 4.9,
    'reseñas': 148,
    'precio': 80,
    'emoji': '🏋️',
    'color': const Color(0xFFE8FAF7),
    'tipo': 'Gimnasio',
    'descripcion':
    'El mejor gimnasio de Tuxtla con más de 200 equipos de última generación.',
    'servicios': ['Pesas', 'Cardio', 'Clases', 'Funcional', 'Lockers', 'Spa'],
    'planes': [
      {'id': 'dia', 'label': 'Día', 'sub': 'Acceso 1 día', 'precio': 80, 'icono': '☀️'},
      {'id': 'semana', 'label': 'Semana', 'sub': 'Acceso 7 días', 'precio': 350, 'icono': '📅'},
      {'id': 'mes', 'label': 'Mes', 'sub': 'Acceso 30 días', 'precio': 800, 'icono': '🗓️'},
    ],
  },
  {
    'id': 'gym2',
    'nombre': 'Club Tenis Tuxtla',
    'ubicacion': 'Col. Centro, Tuxtla',
    'direccion': 'Calle Bienestar #110',
    'horario': '6am – 10pm',
    'rating': 4.9,
    'reseñas': 148,
    'precio': 250,
    'emoji': '🎾',
    'color': const Color(0xFFD0EEFF),
    'tipo': 'Tenis & Pádel',
    'descripcion': 'El mejor club de tenis y pádel en Tuxtla Gutiérrez. Contamos con 6 canchas de tenis en superficie dura y 4 canchas de pádel techadas. Instalaciones de primer nivel con iluminación LED para partidos nocturnos.',
    'servicios': ['Tenis', 'Pádel', 'Vestidores', 'Estacionamiento', 'Cafetería'],
    'canchas': [
      {'nombre':'Cancha A1','tipo':'Tenis · Superficie dura', 'precio':250,'disponible':true},
      {'nombre':'Cancha A2','tipo':'Tenis · Superficie dura', 'precio':250,'disponible':true},
      {'nombre':'Cancha P1','tipo':'Pádel · Techada',         'precio':300,'disponible':true},
      {'nombre':'Cancha P2','tipo':'Pádel · Techada',         'precio':300,'disponible':true},
    ],
    'planes': [
      {'id': 'dia',    'label': 'Día',    'sub': 'Acceso 1 día',   'precio': 80,  'icono': '☀️'},
      {'id': 'semana', 'label': 'Semana', 'sub': 'Acceso 7 días',  'precio': 350, 'icono': '📅'},
      {'id': 'mes',    'label': 'Mes',    'sub': 'Acceso 30 días', 'precio': 800, 'icono': '🗓️'},
    ],
    'horarios': ['07:00','08:00','09:00','10:00','11:00','12:00','13:00','15:00','16:00','17:00','18:00','19:00','20:00'],
    'reviews': [
      {'n':'Jorge López',   'f':'Hace 1 semana',  'r':5, 'c':const Color(0xFF5C6BC0), 't':'Excelentes instalaciones, las canchas siempre limpias y en buen estado. El personal muy atento. ¡Definitivamente regreso!'},
      {'n':'María Aguirre', 'f':'Hace 2 semanas', 'r':5, 'c':const Color(0xFF26A69A), 't':'Me encanta la cancha de pádel techada, perfecta para los días de lluvia. La app para reservar es muy fácil de usar.'},
    ],
  },
  {
    'id': 'gym3',
    'nombre': 'Funcional Box Gym',
    'ubicacion': 'Col. Jardines, Tuxtla',
    'direccion': 'Av. Central Oriente #350',
    'horario': '6am – 9pm',
    'rating': 4.7,
    'reseñas': 93,
    'precio': 70,
    'emoji': '🔥',
    'color': const Color(0xFFFFF3CC),
    'tipo': 'CrossFit & Box',
    'descripcion': 'Especialistas en entrenamiento funcional y CrossFit. Clases en grupos reducidos para máxima atención personalizada. Equipo de alto rendimiento y coaches certificados.',
    'servicios': ['CrossFit', 'Box', 'Funcional', 'Nutrición', 'Lockers'],
    'planes': [
      {'id': 'clase',  'label': 'Clase',   'sub': '1 sesión',          'precio': 70,  'icono': '⚡'},
      {'id': 'semana', 'label': 'Semana',  'sub': '5 clases',          'precio': 280, 'icono': '📅'},
      {'id': 'mes',    'label': 'Mes',     'sub': 'Clases ilimitadas', 'precio': 900, 'icono': '🗓️'},
    ],
    'horarios': ['06:00','07:00','08:00','10:00','12:00','17:00','18:00','19:00','20:00'],
    'reviews': [
      {'n':'Carlos Ruiz',  'f':'Hace 3 días',    'r':5, 'c':const Color(0xFFEF5350), 't':'Los coaches son increíbles, muy motivadores. Las clases son intensas pero bien estructuradas.'},
      {'n':'Ana Torres',   'f':'Hace 1 semana',  'r':4, 'c':const Color(0xFFAB47BC), 't':'Excelente ambiente y comunidad. Me encanta entrenar aquí, aunque el estacionamiento es limitado.'},
    ],
  },
];

// ─────────────────────────────────────────────────────────
// GymListPage — lista de gimnasios
// ─────────────────────────────────────────────────────────
class GymListPage extends StatelessWidget {
  const GymListPage({super.key});

  static const tealMain = Color(0xFF00C2A8);
  static const bgColor  = Color(0xFFF4F6F9);
  static const textDark = Color(0xFF1A1F36);
  static const textMuted = Color(0xFF8A94A6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: gymData.length,
                itemBuilder: (_, i) => _gymCard(context, gymData[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: textDark, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Text('Gimnasios y Clubes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark)),
        ],
      ),
    );
  }

  Widget _gymCard(BuildContext context, Map<String, dynamic> gym) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GymDetailPage(gym: gym)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner superior
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (gym['color'] as Color),
                      (gym['color'] as Color).withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 16,
                      bottom: 8,
                      child: Text(
                        gym['emoji'],
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          gym['tipo'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: textDark,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gym['nombre'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFFFC107), size: 13),
                            const SizedBox(width: 3),
                            Text(
                              '${gym['rating']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8A6914),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: tealMain, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        gym['ubicacion'],
                        style: const TextStyle(color: textMuted, fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _chip(Icons.attach_money_rounded,
                          'Desde \$${gym['precio']}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// GymDetailPage — detalle de un gimnasio
// ─────────────────────────────────────────────────────────
class GymDetailPage extends StatefulWidget {
  final Map<String, dynamic> gym;
  const GymDetailPage({super.key, required this.gym});

  @override
  State<GymDetailPage> createState() => _GymDetailPageState();
}

class _GymDetailPageState extends State<GymDetailPage>
    with SingleTickerProviderStateMixin {
  static const tealMain  = Color(0xFF00C2A8);
  static const tealDk    = Color(0xFF009E88);
  static const bgColor   = Color(0xFFF4F6F9);
  static const cardColor = Colors.white;
  static const textDark  = Color(0xFF1A1F36);
  static const textMuted = Color(0xFF8A94A6);
  static const accentAmb = Color(0xFFFFC107);

  String?   _planSel;
  //String?   _horaSel;
  String?   _canchaSel;   // solo para clubs con canchas
  bool      _favorito = false;

  late AnimationController _ctrl;
  late Animation<double>   _anim;

  Map<String, dynamic> get g => widget.gym;
  bool get tieneCanchas => (g['canchas'] as List?)?.isNotEmpty == true;

  //Se hizo modificacion de logica al reservar
  bool get _puedeReservar {
    if (tieneCanchas) return _planSel != null && _canchaSel != null;
    return _planSel != null;
  }

  int get _precioTotal {
    if (_planSel == null) return g['precio'] as int;
    final plan = (g['planes'] as List).firstWhere((p) => p['id'] == _planSel);
    return plan['precio'] as int;
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  // ── BUILD ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _anim,
        child: Column(children: [
          _hero(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _infoCard(),
                _label('Selecciona una Suscripcion', Icons.card_membership_rounded),
                _planes(),
                // Canchas (solo clubs como Club Tenis)
                if (tieneCanchas && _planSel != null) ...[
                  _label('Canchas disponibles', Icons.sports_tennis_rounded),
                  _canchas(),
                ],
                // Horarios
                //if (_planSel != null && (!tieneCanchas || _canchaSel != null)) ...[
                  //_label('Horarios disponibles — Hoy', Icons.schedule_rounded),
                  //_horarios(),
                //],
                _label('Ubicación', Icons.location_on_rounded),
                _ubicacion(),
                _label('Reseñas', Icons.star_rounded),
                _resenas(),
                const SizedBox(height: 110),
              ]),
            ),
          ),
        ]),
      ),
      bottomSheet: _bottomBar(context),
    );
  }

  // ── HERO ───────────────────────────────────────────────
  Widget _hero(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 200 + top,
      child: Stack(fit: StackFit.expand, children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [
                (g['color'] as Color).withOpacity(0.8),
                (g['color'] as Color),
              ],
            ),
          ),
        ),
        // Patrón diagonal
        Positioned.fill(child: CustomPaint(painter: _DiagLinePainter())),
        // Círculos decorativos
        Positioned(right: -30, bottom: -20, child: Container(
          width: 180, height: 180,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.05)),
        )),
        // Emoji grande
        Positioned(right: 24, bottom: 20,
            child: Text(g['emoji'], style: const TextStyle(fontSize: 80))),
        // Info superpuesta
        Positioned(left: 16, bottom: 18, right: 100,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(g['tipo'],
                  style: const TextStyle(color: Colors.white, fontSize: 10,
                      fontWeight: FontWeight.w700, letterSpacing: 0.8)),
            ),
            const SizedBox(height: 6),
            Text(g['nombre'],
                style: const TextStyle(color: Colors.white, fontSize: 21,
                    fontWeight: FontWeight.w900, height: 1.1)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.access_time_rounded, color: Colors.white70, size: 12),
              const SizedBox(width: 4),
              Text(g['horario'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ]),
        ),
        // Botones top
        Positioned(
          top: top + 8, left: 12, right: 12,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _btn(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
            _btn(
              _favorito ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  () => setState(() => _favorito = !_favorito),
              color: _favorito ? const Color(0xFFFF5A7E) : Colors.white,
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, {Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // ── INFO CARD ──────────────────────────────────────────
  Widget _infoCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(g['nombre'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on_rounded, color: tealMain, size: 13),
              const SizedBox(width: 4),
              Expanded(child: Text(g['ubicacion'],
                  style: const TextStyle(color: textMuted, fontSize: 12))),
            ]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.star_rounded, color: accentAmb, size: 14),
                const SizedBox(width: 4),
                Text('${g['rating']}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF8A6914))),
              ]),
            ),
            const SizedBox(height: 4),
            Text('(${g['reseñas']} reseñas)',
                style: const TextStyle(color: textMuted, fontSize: 11)),
          ]),
        ]),
        const SizedBox(height: 14),
        // Servicios chips
        Wrap(
          spacing: 6, runSpacing: 6,
          children: (g['servicios'] as List<String>).map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: tealMain.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tealMain.withOpacity(0.2)),
            ),
            child: Text(s, style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: tealDk)),
          )).toList(),
        ),
        const SizedBox(height: 14),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 12),
        Text(g['descripcion'],
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.55)),
      ]),
    );
  }

  // ── LABEL ──────────────────────────────────────────────
  Widget _label(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: tealMain.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: tealMain, size: 14),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w800, color: textDark)),
      ]),
    );
  }

  // ── PLANES ─────────────────────────────────────────────
  Widget _planes() {
    final planes = (g['planes'] as List?) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: planes.map((p) {
          final sel = _planSel == p['id'];
          final idx = planes.indexOf(p);

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _planSel = p['id'] as String;
                _canchaSel = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(
                    right: idx < planes.length - 1 ? 10 : 0),
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFFE8FAF7) : cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: sel ? tealMain : Colors.grey.shade200,
                    width: sel ? 2 : 1.5,
                  ),
                  boxShadow: sel
                      ? [
                    BoxShadow(
                        color: tealMain.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                      : [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6)
                  ],
                ),
                child: Column(children: [
                  Text(p['icono'] as String,
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 6),
                  Text(
                    p['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: sel ? tealMain : textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p['sub'] as String,
                    style:
                    const TextStyle(fontSize: 10, color: textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${p['precio']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: sel ? tealMain : textDark,
                    ),
                  ),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

// ── CANCHAS ───────────────────────────────────────────────
  Widget _canchas() {
    final canchas = (g['canchas'] as List?) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: canchas.map((c) {
          final sel = _canchaSel == c['nombre'];

          return GestureDetector(
            onTap: () => setState(() {
              _canchaSel = c['nombre'] as String;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFE8FAF7) : cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: sel ? tealMain : Colors.grey.shade200,
                  width: sel ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c['nombre'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: sel ? tealMain : textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    c['tipo'] as String,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${c['precio']}/hr',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: sel ? tealMain : textDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── HORARIOS ───────────────────────────────────────────
  Widget _horarios() {
    final lista = (g['horarios'] as List?)?.cast<String>() ?? [];
    if (lista.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: lista.map((h) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Text(
              h,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  // ── UBICACIÓN ──────────────────────────────────────────
  Widget _ubicacion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 140,
          decoration: const BoxDecoration(color: Color(0xFFDEEFDE)),
          child: Stack(children: [
            Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
            Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,3))],
                ),
                child: Column(children: [
                  Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.location_on_rounded, color: tealMain, size: 15),
                    SizedBox(width: 5),
                    Text('Ver en mapa', style: TextStyle(
                        color: tealMain, fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                  const SizedBox(height: 3),
                  Text(widget.gym['direccion'] ?? '',
                      style: const TextStyle(color: textMuted, fontSize: 11)),
                ]),
              ),
              const SizedBox(height: 4),
              Container(width: 2, height: 10, color: tealMain),
              Container(width: 8, height: 8,
                  decoration: const BoxDecoration(color: tealMain, shape: BoxShape.circle)),
            ])),
          ]),
        ),
      ),
    );
  }

  // ── RESEÑAS ────────────────────────────────────────────
  Widget _resenas() {
    final reviews = (g['reviews'] as List?) ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        // Resumen rating
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: _cardDecor(),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${g['rating']}', style: const TextStyle(
                  fontSize: 40, fontWeight: FontWeight.w900, color: textDark, height: 1)),
              const SizedBox(height: 4),
              Row(children: List.generate(5, (i) =>
              const Icon(Icons.star_rounded, color: accentAmb, size: 15))),
              const SizedBox(height: 4),
              Text('${g['reseñas']} reseñas',
                  style: const TextStyle(color: textMuted, fontSize: 12)),
            ]),
            const SizedBox(width: 20),
            Expanded(child: Column(
              children: [5,4,3,2,1].map((s) {
                final vals = [0.78, 0.14, 0.05, 0.02, 0.01];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(children: [
                    Text('$s', style: const TextStyle(fontSize: 11, color: textMuted)),
                    const SizedBox(width: 6),
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: vals[5-s], minHeight: 5,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(accentAmb),
                      ),
                    )),
                  ]),
                );
              }).toList(),
            )),
          ]),
        ),
        // Cards
        ...reviews.map((r) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: _cardDecor(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: (r['c'] as Color).withOpacity(0.15),
                child: Text((r['n'] as String).split(' ').map((w) => w[0]).take(2).join(),
                    style: TextStyle(fontWeight: FontWeight.w800, color: r['c'] as Color, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['n'] as String, style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13, color: textDark)),
                Text(r['f'] as String,
                    style: const TextStyle(color: textMuted, fontSize: 11)),
              ])),
              Row(children: List.generate(r['r'] as int, (_) =>
              const Icon(Icons.star_rounded, color: accentAmb, size: 13))),
            ]),
            const SizedBox(height: 10),
            Text(r['t'] as String,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.45)),
          ]),
        )),
      ]),
    );
  }

  // ── BOTTOM BAR ─────────────────────────────────────────
  Widget _bottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 20, offset: const Offset(0,-4))],
      ),
      child: Row(children: [
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Total', style: TextStyle(fontSize: 11, color: textMuted)),
          Text('\$$_precioTotal', style: const TextStyle(
              fontSize: 23, fontWeight: FontWeight.w900, color: textDark)),
        ]),
        const SizedBox(width: 16),
        Expanded(child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _puedeReservar ? tealMain : Colors.grey.shade200,
            foregroundColor: _puedeReservar ? Colors.white : textMuted,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _puedeReservar
              ? () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => PagoGymPage(
              gym: g,
              plan: (g['planes'] as List).firstWhere((p) => p['id'] == _planSel),
              cancha: _canchaSel,
            ),
          ))
              : null,

          child: Text(
            _puedeReservar ? 'Obtener Suscripcion' : 'Selecciona opciones',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        )),
      ]),
    );
  }

  BoxDecoration _cardDecor() => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0,3))],
  );
}

// ── PAINTERS ─────────────────────────────────────────────
class _DiagLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.06)..strokeWidth = 1;
    for (double x = 0; x < size.width + 60; x += 36) {
      canvas.drawLine(Offset(x - 60, 0), Offset(x, size.height), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF81C784).withOpacity(0.35)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 22) canvas.drawLine(Offset(x,0), Offset(x,size.height), p);
    for (double y = 0; y < size.height; y += 22) canvas.drawLine(Offset(0,y), Offset(size.width,y), p);
  }
  @override bool shouldRepaint(_) => false;
}