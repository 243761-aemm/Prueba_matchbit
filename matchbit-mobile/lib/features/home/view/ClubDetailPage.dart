import 'package:flutter/material.dart';

class ClubDetailPage extends StatefulWidget {
  final Map<String, dynamic> club;
  const ClubDetailPage({super.key, required this.club});

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage>
    with TickerProviderStateMixin {
  // ── Paleta ───────────────────────────────────────────────
  static const primary    = Color(0xFF00C2A8);
  static const primaryDk  = Color(0xFF009E88);
  static const bgColor    = Color(0xFFF4F6F9);
  static const cardColor  = Colors.white;
  static const textDark   = Color(0xFF1A1F36);
  static const textMuted  = Color(0xFF8A94A6);
  static const accentAmb  = Color(0xFFFFC107);

  // ── Estado ───────────────────────────────────────────────
  DateTime? selectedDate;
  String?   selectedCourt;
  String?   selectedHour;
  int?      selectedDuration; // 1, 2 o 3 horas
  String?   paymentMethod;
  bool      _favorito = false;

  late AnimationController _entryCtrl;
  late Animation<double>   _entryAnim;

  // Horarios disponibles por cancha
  final Map<String, List<String>> horariosPorCancha = {
    'Cancha A1': ['08:00','09:00','10:00','13:00','14:00','16:00','17:00'],
    'Cancha P1': ['09:00','11:00','12:00','15:00','16:00'],
    'Cancha A2': ['08:00','10:00','11:00','12:00','14:00','15:00','17:00'],
  };

  final canchas = [
    {'nombre':'Cancha A1','tipo':'Tenis','precio':250,'disponible':true, 'icono':'🎾'},
    {'nombre':'Cancha P1','tipo':'Pádel','precio':300,'disponible':false,'icono':'🏓'},
    {'nombre':'Cancha A2','tipo':'Tenis','precio':200,'disponible':true, 'icono':'🎾'},
  ];

  // Flujo: Fecha → Cancha → Horario+Duración → Pago
  int get currentStep {
    if (selectedDate     == null) return 0;
    if (selectedCourt    == null) return 1;
    if (selectedHour     == null || selectedDuration == null) return 2;
    if (paymentMethod    == null) return 3;
    return 4;
  }

  int get precioTotal {
    final cancha = canchas.firstWhere(
          (c) => c['nombre'] == selectedCourt,
      orElse: () => {'precio': widget.club['precio'] ?? 180},
    );
    return (cancha['precio'] as int) * (selectedDuration ?? 1);
  }

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _entryAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entryCtrl.forward();
  }

  @override
  void dispose() { _entryCtrl.dispose(); super.dispose(); }

  // ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _entryAnim,
        child: Column(
          children: [
            _hero(context),
            _stepper(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _clubCard(),
                    _sectionLabel('Selecciona fecha', Icons.calendar_today_rounded),
                    _fechas(),
                    if (selectedDate != null) ...[
                      _sectionLabel('Canchas disponibles', Icons.sports_tennis_rounded),
                      _canchas(),
                    ],
                    if (selectedCourt != null) ...[
                      _sectionLabel('Horario', Icons.schedule_rounded),
                      _horarios(),
                      const SizedBox(height: 6),
                      _sectionLabel('Duración', Icons.timer_rounded),
                      _duracion(),
                    ],
                    if (selectedHour != null && selectedDuration != null) ...[
                      _sectionLabel('Método de pago', Icons.payment_rounded),
                      _pago(),
                    ],
                    _sectionLabel('Ubicación', Icons.location_on_rounded),
                    _mapa(),
                    _sectionLabel('Reseñas', Icons.star_rounded),
                    _resenas(),
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _bottomBar(),
    );
  }

  // ── HERO ─────────────────────────────────────────────────
  Widget _hero(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 220 + top,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradiente base
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00C2A8), Color(0xFF007A8A)],
              ),
            ),
          ),
          // Patrón geométrico
          Positioned.fill(child: CustomPaint(painter: _HeroPatternPainter())),
          // Círculo decorativo grande
          Positioned(
            right: -40, bottom: -30,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 20, bottom: 10,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          // Emoji del deporte
          Positioned(
            right: 28, bottom: 24,
            child: Text(
              widget.club['emoji'] ?? '🎾',
              style: const TextStyle(fontSize: 80),
            ),
          ),
          // Info del club superpuesta
          Positioned(
            left: 16, bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.club['tipo'] ?? 'PÁDEL & TENIS',
                    style: const TextStyle(
                      color: Colors.white, fontSize: 10,
                      fontWeight: FontWeight.w700, letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.club['nombre'] ?? 'Club de Pádel Elite',
                  style: const TextStyle(
                    color: Colors.white, fontSize: 22,
                    fontWeight: FontWeight.w900, height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white70, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    widget.club['ubicacion'] ?? 'Col. Patria Nueva',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ]),
              ],
            ),
          ),
          // Botones top
          Positioned(
            top: top + 8, left: 12, right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _heroBtn(Icons.arrow_back_ios_new_rounded,
                        () => Navigator.pop(context)),
                Row(children: [
                  _heroBtn(
                    _favorito ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        () => setState(() => _favorito = !_favorito),
                    color: _favorito ? const Color(0xFFFF5A7E) : Colors.white,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBtn(IconData icon, VoidCallback onTap, {Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // ── STEPPER ──────────────────────────────────────────────
  Widget _stepper() {
    final steps = ['Fecha', 'Cancha', 'Horario', 'Pago'];
    return Container(
      color: cardColor,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: List.generate(steps.length, (i) {
          final done   = i < currentStep;
          final active = i == currentStep;
          final color  = done || active ? primary : Colors.grey.shade300;
          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: done ? primary : active ? primary.withOpacity(0.1) : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: active ? Border.all(color: primary, width: 2) : null,
                      ),
                      child: Center(
                        child: done
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                            : Text('${i+1}', style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800,
                            color: active ? primary : textMuted)),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(steps[i], style: TextStyle(
                      fontSize: 10,
                      fontWeight: active || done ? FontWeight.w700 : FontWeight.w400,
                      color: active || done ? primary : textMuted,
                    )),
                  ],
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2, margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: done
                            ? const LinearGradient(colors: [primary, primaryDk])
                            : null,
                        color: done ? null : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── CLUB CARD ────────────────────────────────────────────
  Widget _clubCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating + stats
          Row(
            children: [
              _statPill(Icons.star_rounded, '4.8', const Color(0xFFFFF8E1), accentAmb, const Color(0xFF8A6914)),
              const SizedBox(width: 8),
              _statPill(Icons.access_time_rounded, 'Abre 7am', const Color(0xFFE8FAF7), primary, primaryDk),
              const SizedBox(width: 8),
              _statPill(Icons.sports_tennis_rounded, '6 canchas', const Color(0xFFEEF2FF), const Color(0xFF5C6BC0), const Color(0xFF3949AB)),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 14),
          // Amenidades
          Row(
            children: [
              _amenity(Icons.wifi_rounded, 'WiFi'),
              _amenity(Icons.local_parking_rounded, 'Parking'),
              _amenity(Icons.shower_rounded, 'Vestidores'),
              _amenity(Icons.coffee_rounded, 'Cafetería'),
            ],
          ),
          if ((widget.club['descripcion'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 12),
            Text(
              widget.club['descripcion'],
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.55),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statPill(IconData icon, String label, Color bg, Color iconColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: iconColor),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textColor)),
      ]),
    );
  }

  Widget _amenity(IconData icon, String label) {
    return Expanded(
      child: Column(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primary, size: 18),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ── SECTION LABEL ────────────────────────────────────────
  Widget _sectionLabel(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primary, size: 14),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w800, color: textDark)),
      ]),
    );
  }

  // ── FECHAS ───────────────────────────────────────────────
  Widget _fechas() {
    return SizedBox(
      height: 84,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (_, i) {
          final date = DateTime.now().add(Duration(days: i));
          final sel  = selectedDate?.day == date.day && selectedDate?.month == date.month;
          final days = ['Dom','Lun','Mar','Mié','Jue','Vie','Sáb'];
          return GestureDetector(
            onTap: () => setState(() {
              selectedDate = date; selectedCourt = null;
              selectedHour = null; selectedDuration = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 62, margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: sel ? primary : cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: sel ? primary : Colors.grey.shade200, width: 1.5),
                boxShadow: sel ? [BoxShadow(color: primary.withOpacity(0.35), blurRadius: 14, offset: const Offset(0,5))] : [],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(days[date.weekday % 7],
                    style: TextStyle(fontSize: 10, color: sel ? Colors.white70 : textMuted, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text('${date.day}', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w900,
                    color: sel ? Colors.white : textDark)),
                Text(_mes(date.month),
                    style: TextStyle(fontSize: 10, color: sel ? Colors.white70 : textMuted)),
              ]),
            ),
          );
        },
      ),
    );
  }

  String _mes(int m) => ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'][m-1];

  // ── HORARIOS ─────────────────────────────────────────────
  Widget _horarios() {
    final lista = horariosPorCancha[selectedCourt] ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8, runSpacing: 8,
        children: lista.map((h) {
          final sel = selectedHour == h;
          return GestureDetector(
            onTap: () => setState(() => selectedHour = h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                color: sel ? primary : cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sel ? primary : Colors.grey.shade200, width: 1.5),
                boxShadow: sel ? [BoxShadow(color: primary.withOpacity(0.28), blurRadius: 10)] : [],
              ),
              child: Text(h, style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: sel ? Colors.white : textDark)),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── DURACIÓN ─────────────────────────────────────────────
  Widget _duracion() {
    final cancha = canchas.firstWhere(
          (c) => c['nombre'] == selectedCourt,
      orElse: () => {'precio': 0},
    );
    final precioPorHora = cancha['precio'] as int;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [1, 2, 3].map((hrs) {
          final sel = selectedDuration == hrs;
          final total = precioPorHora * hrs;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedDuration = hrs),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: hrs < 3 ? 10 : 0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: sel ? primary : cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: sel ? primary : Colors.grey.shade200, width: 1.5),
                  boxShadow: sel
                      ? [BoxShadow(color: primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0,4))]
                      : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                ),
                child: Column(children: [
                  Text(
                    '$hrs ${hrs == 1 ? 'hora' : 'horas'}',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w800,
                        color: sel ? Colors.white : textDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$$total',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: sel ? Colors.white70 : textMuted),
                  ),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── CANCHAS ──────────────────────────────────────────────
  Widget _canchas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: canchas.map((c) {
          final disp = c['disponible'] as bool;
          final sel  = selectedCourt == c['nombre'];
          return GestureDetector(
            onTap: disp ? () => setState(() {
              selectedCourt = c['nombre'] as String;
              selectedHour = null;
              selectedDuration = null;
            }) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFE8FAF7) : disp ? cardColor : const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: sel ? primary : disp ? Colors.grey.shade200 : Colors.grey.shade100,
                  width: sel ? 2 : 1.5,
                ),
                boxShadow: sel
                    ? [BoxShadow(color: primary.withOpacity(0.12), blurRadius: 14, offset: const Offset(0,4))]
                    : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
              ),
              child: Row(children: [
                // Ícono con fondo degradado
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: sel
                          ? [primary.withOpacity(0.2), primary.withOpacity(0.08)]
                          : disp
                          ? [const Color(0xFFF0F0F0), const Color(0xFFE8E8E8)]
                          : [const Color(0xFFEAEAEA), const Color(0xFFE0E0E0)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(c['icono'] as String,
                      style: TextStyle(fontSize: 24, color: disp ? null : null))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['nombre'] as String, style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 15,
                        color: disp ? textDark : textMuted)),
                    const SizedBox(height: 2),
                    Text(c['tipo'] as String,
                        style: const TextStyle(color: textMuted, fontSize: 12)),
                  ],
                )),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('\$${c['precio']}/hr', style: TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 15,
                      color: sel ? primary : disp ? textDark : textMuted)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: disp ? const Color(0xFFE8FAF7) : const Color(0xFFFFECEC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      disp ? 'Disponible' : 'Ocupada',
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: disp ? primaryDk : const Color(0xFFD32F2F)),
                    ),
                  ),
                ]),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── PAGO ─────────────────────────────────────────────────
  Widget _pago() {
    final metodos = [
      {'id':'tarjeta',      'label':'Tarjeta',      'sub':'Débito o crédito',   'icon':Icons.credit_card_rounded,  'color':const Color(0xFFEEF2FF), 'ic':const Color(0xFF5C6BC0)},
      {'id':'oxxo',         'label':'OXXO Pay',     'sub':'En efectivo',         'icon':Icons.store_rounded,        'color':const Color(0xFFFFF3E0), 'ic':const Color(0xFFE65100)},
      {'id':'transferencia','label':'Transferencia','sub':'SPEI / interbancaria','icon':Icons.account_balance_rounded,'color':const Color(0xFFE8FAF7), 'ic':primary},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: metodos.map((m) {
          final sel = paymentMethod == m['id'];
          return GestureDetector(
            onTap: () => setState(() => paymentMethod = m['id'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFE8FAF7) : cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: sel ? primary : Colors.grey.shade200, width: sel ? 2 : 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: sel ? primary.withOpacity(0.12) : (m['color'] as Color),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(m['icon'] as IconData,
                      color: sel ? primary : (m['ic'] as Color), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['label'] as String, style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14,
                        color: sel ? primary : textDark)),
                    Text(m['sub'] as String,
                        style: const TextStyle(color: textMuted, fontSize: 12)),
                  ],
                )),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: sel
                      ? const Icon(Icons.check_circle_rounded, color: primary, size: 22, key: ValueKey('check'))
                      : Container(key: const ValueKey('circle'),
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                      )),
                ),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── MAPA ─────────────────────────────────────────────────
  Widget _mapa() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 150,
          decoration: const BoxDecoration(color: Color(0xFFDEEFDE)),
          child: Stack(children: [
            Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
            // Marcador central
            Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0,3))],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.location_on_rounded, color: primary, size: 16),
                    SizedBox(width: 6),
                    Text('Ver en mapa', style: TextStyle(
                        color: primary, fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                ),
                const SizedBox(height: 4),
                Container(width: 2, height: 10, color: primary),
                Container(width: 8, height: 8,
                    decoration: BoxDecoration(color: primary, shape: BoxShape.circle)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  // ── RESEÑAS ──────────────────────────────────────────────
  Widget _resenas() {
    final reviews = [
      {'n':'Jorge', 't':'Muy buen lugar, instalaciones increíbles 🔥', 'r':5, 'c':const Color(0xFF5C6BC0), 'fecha':'Hace 2 días'},
      {'n':'María', 't':'Excelente servicio, muy atentos con los clientes.', 'r':4, 'c':const Color(0xFF26A69A), 'fecha':'Hace 1 semana'},
      {'n':'Carlos','t':'Canchas en perfecto estado, buen precio.', 'r':5, 'c':const Color(0xFFEF5350), 'fecha':'Hace 2 semanas'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Resumen de rating
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: _cardDecor(),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('4.8', style: TextStyle(
                    fontSize: 42, fontWeight: FontWeight.w900, color: textDark, height: 1)),
                const SizedBox(height: 4),
                Row(children: List.generate(5, (i) =>
                    Icon(i < 5 ? Icons.star_rounded : Icons.star_border_rounded,
                        color: accentAmb, size: 16))),
                const SizedBox(height: 4),
                const Text('32 reseñas', style: TextStyle(color: textMuted, fontSize: 12)),
              ]),
              const SizedBox(width: 20),
              Expanded(child: Column(
                children: [5,4,3,2,1].map((stars) {
                  final vals = [0.75, 0.15, 0.05, 0.03, 0.02];
                  final pct  = vals[5 - stars];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(children: [
                      Text('$stars', style: const TextStyle(fontSize: 11, color: textMuted)),
                      const SizedBox(width: 6),
                      Expanded(child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct, minHeight: 6,
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
          // Cards reseñas
          ...reviews.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: _cardDecor(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                  radius: 18, backgroundColor: (r['c'] as Color).withOpacity(0.15),
                  child: Text((r['n'] as String)[0],
                      style: TextStyle(fontWeight: FontWeight.w800, color: r['c'] as Color, fontSize: 14)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r['n'] as String, style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13, color: textDark)),
                  Text(r['fecha'] as String,
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
        ],
      ),
    );
  }

  // ── BOTTOM BAR ───────────────────────────────────────────
  Widget _bottomBar() {
    final enabled = selectedDate != null && selectedCourt != null &&
        selectedHour != null && selectedDuration != null &&
        paymentMethod != null;
    final cancha = canchas.firstWhere(
          (c) => c['nombre'] == selectedCourt,
      orElse: () => {'precio': widget.club['precio'] ?? 180},
    );
    final precioPorHora = cancha['precio'] as int;
    final total = selectedDuration != null ? precioPorHora * selectedDuration! : precioPorHora;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 20, offset: const Offset(0,-4))],
      ),
      child: Row(children: [
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            selectedDuration != null ? 'Total · $selectedDuration ${selectedDuration == 1 ? 'hora' : 'horas'}' : 'Precio por hora',
            style: const TextStyle(fontSize: 11, color: textMuted),
          ),
          Text('\$$total', style: const TextStyle(
              fontSize: 23, fontWeight: FontWeight.w900, color: textDark)),
        ]),
        const SizedBox(width: 16),
        Expanded(child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? primary : Colors.grey.shade200,
            foregroundColor: enabled ? Colors.white : textMuted,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: enabled ? _confirmar : null,
          child: Text(
            enabled ? 'Confirmar reserva' : 'Selecciona opciones',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        )),
      ]),
    );
  }

  // ── CONFIRMAR ────────────────────────────────────────────
  void _confirmar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2))),
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.12), shape: BoxShape.circle,
              border: Border.all(color: primary.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.check_rounded, color: primary, size: 38),
          ),
          const SizedBox(height: 16),
          const Text('¡Reserva confirmada!', style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w900, color: textDark)),
          const SizedBox(height: 8),
          Text(
            'Cancha $selectedCourt · ${selectedDate?.day}/${selectedDate?.month} a las $selectedHour · $selectedDuration ${selectedDuration == 1 ? 'hora' : 'horas'}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: textMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          // Código de acceso
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF9), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withOpacity(0.25)),
            ),
            child: Column(children: const [
              Text('CÓDIGO DE ACCESO', style: TextStyle(
                  color: primary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              SizedBox(height: 6),
              Text('5823', style: TextStyle(
                  color: primary, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 6)),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary, foregroundColor: Colors.white,
                elevation: 0, padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Ver mis reservas',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
            ),
          ),
        ]),
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────
  BoxDecoration _cardDecor({double radius = 18}) => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0,3))],
  );
}

// ── PAINTERS ─────────────────────────────────────────────

class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.07)..strokeWidth = 1..style = PaintingStyle.stroke;
    for (double x = 0; x < size.width + 60; x += 40) {
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