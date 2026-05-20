import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmacionGymPage extends StatefulWidget {
  final Map<String, dynamic> gym;
  final Map<String, dynamic> plan;

  final String? cancha;
  final int total;

  const ConfirmacionGymPage({
    super.key,
    required this.gym,
    required this.plan,

    this.cancha,
    required this.total,
  });

  @override
  State<ConfirmacionGymPage> createState() => _ConfirmacionGymPageState();
}

class _ConfirmacionGymPageState extends State<ConfirmacionGymPage>
    with SingleTickerProviderStateMixin {
  static const tealMain  = Color(0xFF00C2A8);
  static const bgColor   = Color(0xFFF4F6F9);
  static const cardColor = Colors.white;
  static const textDark  = Color(0xFF1A1F36);
  static const textMuted = Color(0xFF8A94A6);

  late final String _codigo;
  late final String _reservaId;
  late AnimationController _ctrl;
  late Animation<double>   _scaleAnim;
  bool _copiado = false;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _codigo    = (1000 + rng.nextInt(9000)).toString();
    _reservaId = 'MB-${DateTime.now().year}-${String.fromCharCodes(List.generate(4, (_) => 65 + rng.nextInt(26)))}';
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  String _mes(int m) => ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'][m-1];

  String get _fechaStr {
    final hoy = DateTime.now();
    return 'Hoy, ${hoy.day} ${_mes(hoy.month)} ${hoy.year}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(children: [
          _topBar(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const SizedBox(height: 16),
                _checkIcon(),
                const SizedBox(height: 16),
                const Text('¡Suscripcion Confirmada!', style: TextStyle(
                    color: textDark, fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(
                  'Tu Suscripcion Ahora etsa Activa. Te enviamos\nun correo y WhatsApp con los detalles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 28),
                _detalles(),
                const SizedBox(height: 16),
                _codigoCard(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
          _bottomBtns(context),
        ]),
      ),
    );
  }

  // ── TOP BAR ────────────────────────────────────────────
  Widget _topBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: cardColor,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: tealMain.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: tealMain.withOpacity(0.3)),
          ),
          child: const Row(children: [
            Icon(Icons.check_rounded, color: tealMain, size: 13),
            SizedBox(width: 5),
            Text('¡Acción realizada!',
                style: TextStyle(color: tealMain, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }

  // ── CHECK ICON ─────────────────────────────────────────
  Widget _checkIcon() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: tealMain.withOpacity(0.12), shape: BoxShape.circle,
          border: Border.all(color: tealMain.withOpacity(0.3), width: 2),
        ),
        child: const Icon(Icons.check_rounded, color: tealMain, size: 42),
      ),
    );
  }

  // ── DETALLES ───────────────────────────────────────────
  Widget _detalles() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,2))],
      ),
      child: Column(children: [
        _row('Suscripcion #',  _reservaId,    color: tealMain),
        _div(),
        _row('Club',       widget.gym['nombre']),
        _div(),
        _row(widget.cancha != null ? 'Cancha' : 'Plan',
            widget.cancha ?? widget.plan['label']),
        _div(),
        _row('Fecha',      _fechaStr),
        _div(),
        //_row('Horario',    '${widget.hora} AM – $_horaFin AM'),
        _div(),
        _row('Total pagado', '\$${widget.total}.00', bold: true, color: tealMain),
      ]),
    );
  }

  Widget _row(String label, String val, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: textMuted, fontSize: 13)),
        Flexible(
          child: Text(val, textAlign: TextAlign.right, style: TextStyle(
              color: color ?? textDark, fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
        ),
      ]),
    );
  }

  Widget _div() => const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 16, endIndent: 16);

  // ── CÓDIGO ─────────────────────────────────────────────
  Widget _codigoCard() {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: _codigo));
        setState(() => _copiado = true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _copiado = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: _copiado ? const Color(0xFFE8FAF7) : const Color(0xFFF0FDF9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tealMain.withOpacity(_copiado ? 0.6 : 0.25), width: 1.5),
        ),
        child: Column(children: [
          const Text('CÓDIGO DE ACCESO AL CLUB', style: TextStyle(
              color: tealMain, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Text(_codigo, style: const TextStyle(
              color: tealMain, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 6)),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _copiado
                ? const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.check_rounded, color: tealMain, size: 13),
              SizedBox(width: 5),
              Text('¡Copiado!', key: ValueKey('c'),
                  style: TextStyle(color: tealMain, fontSize: 12, fontWeight: FontWeight.w600)),
            ])
                : Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.copy_rounded, color: Colors.grey.shade400, size: 13),
              const SizedBox(width: 5),
              Text('Toca para copiar', key: const ValueKey('e'),
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── BOTTOM BTNS ────────────────────────────────────────
  Widget _bottomBtns(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0,-4))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tealMain, foregroundColor: Colors.white,
              elevation: 0, padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text('Ver mis reservaciones',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: textMuted,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text('Ir al inicio',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ),
        ),
      ]),
    );
  }
}