import 'package:flutter/material.dart';
import 'package:taxis/features/home/view/Confirmaciongympage.dart';

class PagoGymPage extends StatefulWidget {
  final Map<String, dynamic> gym;
  final Map<String, dynamic> plan;

  final String? cancha;

  const PagoGymPage({
    super.key,
    required this.gym,
    required this.plan,

    this.cancha,
  });

  @override
  State<PagoGymPage> createState() => _PagoGymPageState();
}

class _PagoGymPageState extends State<PagoGymPage> {
  static const tealMain  = Color(0xFF00C2A8);
  static const bgColor   = Color(0xFFF4F6F9);
  static const cardColor = Colors.white;
  static const textDark  = Color(0xFF1A1F36);
  static const textMuted = Color(0xFF8A94A6);

  String _metodoPago = 'tarjeta';
  bool   _cargando   = false;

  int get subtotal  => widget.plan['precio'] as int;
  int get cargo     => (subtotal * 0.1).round();
  int get total     => subtotal + cargo;

  final _metodos = [
    {'id':'tarjeta',       'label':'Tarjeta de crédito/débito','sub':'Visa, MC, AMEX',                    'icon':Icons.credit_card_rounded,     'color':const Color(0xFFEEF2FF),'ic':const Color(0xFF5C6BC0)},
    {'id':'oxxo',          'label':'OXXO Pay',                 'sub':'Paga en efectivo en cualquier OXXO','icon':Icons.store_rounded,            'color':const Color(0xFFFFF3E0),'ic':const Color(0xFFE65100)},
    {'id':'transferencia', 'label':'Transferencia bancaria',   'sub':'SPEI/CLABE interbancaria',          'icon':Icons.account_balance_rounded,  'color':const Color(0xFFE8FAF7),'ic':tealMain},
    {'id':'puntos',        'label':'Matchbit Points',          'sub':'Tienes 1,240 puntos (\$124 MXN)',   'icon':Icons.stars_rounded,            'color':const Color(0xFFFFF8E1),'ic':const Color(0xFFE65100)},
  ];

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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _resumen(),
                const SizedBox(height: 24),
                _metodosPago(),
                const SizedBox(height: 24),
                _seguridad(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
          _bottomBtn(context),
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
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        const Text('Pago', style: TextStyle(
            color: textDark, fontSize: 18, fontWeight: FontWeight.w800)),
        const Spacer(),
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

  // ── RESUMEN ────────────────────────────────────────────
  Widget _resumen() {
    final hoy = DateTime.now();
    final fechaStr = 'Hoy, ${hoy.day} ${_mes(hoy.month)} ${hoy.year}';


    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Resumen de la Suscripcion',
          style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,2))],
        ),
        child: Column(children: [
          _row('Club',    widget.gym['nombre']),
          _div(),
          _row(widget.cancha != null ? 'Cancha' : 'Plan',
              widget.cancha ?? '${widget.plan['label']} — ${widget.plan['sub']}'),
          _div(),
          _row('Fecha',   fechaStr),
          _div(),
         // _row('Horario', '${ widget.hora} AM – $horaFin AM'),
          _div(),
          _row('Subtotal', '\$$subtotal.00'),
          _div(),
          _row('Cargo de servicio', '\$$cargo.00'),
          _div(),
          _row('Total', '\$$total.00', bold: true, color: tealMain),
        ]),
      ),
    ]);
  }

  Widget _row(String label, String val, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: textMuted, fontSize: 13)),
        Text(val, style: TextStyle(
            color: color ?? textDark, fontSize: 13,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
      ]),
    );
  }

  Widget _div() => const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 16, endIndent: 16);

  // ── MÉTODOS DE PAGO ────────────────────────────────────
  Widget _metodosPago() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Método de pago',
          style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      ..._metodos.map((m) {
        final sel = _metodoPago == m['id'];
        return GestureDetector(
          onTap: () => setState(() => _metodoPago = m['id'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFFE8FAF7) : cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: sel ? tealMain : Colors.grey.shade200, width: sel ? 1.5 : 1),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: sel ? tealMain.withOpacity(0.12) : m['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(m['icon'] as IconData,
                    color: sel ? tealMain : m['ic'] as Color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m['label'] as String, style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13,
                    color: sel ? tealMain : textDark)),
                Text(m['sub'] as String,
                    style: const TextStyle(color: textMuted, fontSize: 11)),
              ])),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: sel
                    ? const Icon(Icons.check_circle_rounded, color: tealMain, size: 20, key: ValueKey('c'))
                    : Container(key: const ValueKey('e'), width: 18, height: 18,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 1.5))),
              ),
            ]),
          ),
        );
      }),
    ]);
  }

  // ── SEGURIDAD ──────────────────────────────────────────
  Widget _seguridad() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.lock_rounded, size: 13, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Text('Tus datos están seguros y encriptados.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ]),
      const SizedBox(height: 4),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Al pagar aceptas los ',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        const Text('Términos y Condiciones.',
            style: TextStyle(color: tealMain, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    ]);
  }

  // ── BOTTOM BTN ─────────────────────────────────────────
  Widget _bottomBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0,-4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: tealMain, foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _cargando ? null : () async {
            setState(() => _cargando = true);
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (_) => ConfirmacionGymPage(
                  gym: widget.gym,
                  plan: widget.plan,

                  cancha: widget.cancha,
                  total: total,
                ),
              ));
            }
          },
          child: _cargando
              ? const SizedBox(width: 20, height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('Pagar \$$total.00 MXN',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      ),
    );
  }

  String _mes(int m) => ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'][m-1];


}