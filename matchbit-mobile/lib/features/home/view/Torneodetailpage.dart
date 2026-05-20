import 'package:flutter/material.dart';
import 'package:taxis/features/home/view/PagoTorneoPage.dart';

class TorneoDetailPage extends StatefulWidget {
  final Map<String, dynamic> torneo;
  const TorneoDetailPage({super.key, required this.torneo});

  @override
  State<TorneoDetailPage> createState() => _TorneoDetailPageState();
}

class _TorneoDetailPageState extends State<TorneoDetailPage>
    with SingleTickerProviderStateMixin {
  static const tealMain   = Color(0xFF00C2A8);
  static const bgColor    = Color(0xFFF4F6F9);
  static const cardColor  = Colors.white;
  static const cardColor2 = Color(0xFFF0F2F5);
  static const textDark   = Color(0xFF1A1F36);
  static const textMuted  = Color(0xFF8A94A6);

  bool _inscrito = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() { _animController.dispose(); super.dispose(); }

  Map<String, dynamic> get t => widget.torneo;
  double get pct => (t['inscritos'] as int) / (t['lugares'] as int);
  bool get esGratis => t['precio'] == 0;
  bool get lleno => (t['inscritos'] as int) >= (t['lugares'] as int);
  int get disponibles => (t['lugares'] as int) - (t['inscritos'] as int);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoSection(),
                    _progresoBarra(),
                    _descripcion(),
                    if ((t['premios'] as List).isNotEmpty) _premiosSection(),
                    _participantesSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            _bottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final gradColors = t['colorGrad'] as List<Color>;
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradColors),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _DotPatternPainter())),
              Center(child: Text(t['emoji'], style: const TextStyle(fontSize: 54))),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12, right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
              if (_inscrito)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: tealMain, borderRadius: BorderRadius.circular(20)),
                  child: const Row(children: [
                    Icon(Icons.check_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text('¡Acción realizada!', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ]),
                ),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: tealMain.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tealMain.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t['emoji'], style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                Text(t['deporte'], style: const TextStyle(color: tealMain, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(t['nombre'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textDark, height: 1.1)),
          const SizedBox(height: 12),
          Row(children: [
            _metaChip(Icons.calendar_today_rounded, '${t['fecha']} de ${t['mes']}, 2025'),
            const SizedBox(width: 12),
            _metaChip(Icons.access_time_rounded, t['hora']),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            _metaChip(Icons.location_on_rounded, t['club']),
            const SizedBox(width: 12),
            _metaChip(Icons.people_alt_rounded, '${t['inscritos']}/${t['lugares']} inscritos'),
          ]),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: textMuted),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _progresoBarra() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PROGRESO DE INSCRIPCIÓN',
              style: TextStyle(color: textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(lleno ? const Color(0xFFFF5252) : tealMain),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${t['inscritos']} inscritos', style: const TextStyle(color: textMuted, fontSize: 12)),
              Text(
                lleno ? 'Sin lugares disponibles' : '$disponibles lugares disponibles',
                style: TextStyle(
                  color: lleno ? const Color(0xFFFF5252) : tealMain,
                  fontSize: 12, fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _descripcion() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Text(t['descripcion'],
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.6)),
    );
  }

  Widget _premiosSection() {
    final premios = t['premios'] as List;
    final medallas = ['🥇', '🥈', '🥉'];
    final labels = ['1er lugar', '2do lugar', '3er lugar'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Premio',
              style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              premios.length > 3 ? 3 : premios.length,
                  (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: i == 0 ? tealMain.withOpacity(0.4) : Colors.grey.shade200,
                      width: i == 0 ? 1.5 : 1,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: [
                      Text(medallas[i], style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(labels[i],
                          style: const TextStyle(color: textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        '\$${(premios[i] as int).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        style: TextStyle(
                          color: i == 0 ? tealMain : textDark,
                          fontSize: 16, fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _participantesSection() {
    final avatarColors = [
      const Color(0xFF5C6BC0), const Color(0xFFEF5350),
      const Color(0xFF26A69A), const Color(0xFFAB47BC), const Color(0xFFFF7043),
    ];
    final names = ['JL', 'MA', 'RG', 'PC', 'EM'];
    final extras = (t['inscritos'] as int) - names.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Participantes',
              style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(names.length, (i) => Transform.translate(
                offset: Offset(-i * 8.0, 0),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: avatarColors[i], shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(child: Text(names[i],
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                ),
              )),
              Transform.translate(
                offset: Offset(-names.length * 8.0, 0),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: cardColor2, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(child: Text('+$extras',
                      style: const TextStyle(color: textMuted, fontSize: 11, fontWeight: FontWeight.w700))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    final precio = t['precio'] as int;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inscripción', style: TextStyle(color: textMuted, fontSize: 11)),
              Text(esGratis ? 'Gratis' : '\$$precio',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: tealMain)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: lleno ? Colors.grey.shade300 : tealMain,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: lleno
                  ? null
                  : () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PagoTorneoPage(torneo: t)),
                ).then((_) => setState(() => _inscrito = true));
              },
              child: Text(lleno ? 'Sin lugares' : 'Inscribirse',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.06)..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }
  @override
  bool shouldRepaint(_) => false;
}