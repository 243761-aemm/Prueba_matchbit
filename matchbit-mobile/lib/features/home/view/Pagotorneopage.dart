import 'package:flutter/material.dart';
import 'package:taxis/features/home/view/ConfirmacionPage.dart';

class PagoTorneoPage extends StatefulWidget {
  final Map<String, dynamic> torneo;
  const PagoTorneoPage({super.key, required this.torneo});

  @override
  State<PagoTorneoPage> createState() => _PagoTorneoPageState();
}

class _PagoTorneoPageState extends State<PagoTorneoPage> {
  static const tealMain   = Color(0xFF00C2A8);
  static const bgColor    = Color(0xFFF4F6F9);
  static const cardColor  = Colors.white;
  static const textDark   = Color(0xFF1A1F36);
  static const textMuted  = Color(0xFF8A94A6);

  String? _metodoPago = 'tarjeta';
  bool _cargando = false;

  Map<String, dynamic> get t => widget.torneo;
  int get precio => t['precio'] as int;
  int get cargoServicio => (precio * 0.1).round();
  int get total => precio + cargoServicio;
  bool get esGratis => precio == 0;

  final _metodos = [
    {'id': 'tarjeta',       'label': 'Tarjeta de crédito/débito', 'sub': 'Visa, MC, AMEX',                    'icon': Icons.credit_card_rounded},
    {'id': 'oxxo',          'label': 'OXXO Pay',                  'sub': 'Paga en efectivo en cualquier OXXO','icon': Icons.store_rounded},
    {'id': 'transferencia', 'label': 'Transferencia bancaria',    'sub': 'SPEI/CLABE interbancaria',           'icon': Icons.account_balance_rounded},
    {'id': 'puntos',        'label': 'Matchbit Points',           'sub': 'Tienes 1,240 puntos (\$124 MXN)',   'icon': Icons.stars_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _resumenCard(),
                    const SizedBox(height: 24),
                    if (!esGratis) _metodosPago(),
                    const SizedBox(height: 24),
                    _seguridadNote(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            _bottomBtn(context),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: cardColor,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: const Color(0xFFF4F6F9), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Text('Pago',
              style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.w800)),
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
        ],
      ),
    );
  }

  Widget _resumenCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resumen de reserva',
            style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              _resumenRow('Club', t['club'] ?? 'Club de Pádel Elite'),
              _divider(),
              _resumenRow('Evento', t['nombre']),
              _divider(),
              _resumenRow('Fecha', '${t['fecha']} de ${t['mes']}, 2025'),
              _divider(),
              _resumenRow('Horario', t['hora']),
              _divider(),
              _resumenRow('Subtotal', esGratis ? 'Gratis' : '\$$precio.00'),
              if (!esGratis) ...[
                _divider(),
                _resumenRow('Cargo de servicio', '\$$cargoServicio.00'),
                _divider(),
                _resumenRow('Total', '\$$total.00', isBold: true, valueColor: tealMain),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _resumenRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: textMuted, fontSize: 13)),
          Text(value,
              style: TextStyle(
                color: valueColor ?? textDark,
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 16, endIndent: 16);

  Widget _metodosPago() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Método de pago',
            style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ..._metodos.map((m) {
          final selected = _metodoPago == m['id'];
          return GestureDetector(
            onTap: () => setState(() => _metodoPago = m['id'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE8FAF7) : cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? tealMain : Colors.grey.shade200,
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: selected ? tealMain.withOpacity(0.15) : const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(m['icon'] as IconData,
                        color: selected ? tealMain : textMuted, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['label'] as String,
                            style: TextStyle(
                              color: selected ? textDark : textDark,
                              fontSize: 13, fontWeight: FontWeight.w600,
                            )),
                        Text(m['sub'] as String,
                            style: const TextStyle(color: textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                  if (selected)
                    const Icon(Icons.check_circle_rounded, color: tealMain, size: 20)
                  else
                    Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _seguridadNote() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_rounded, size: 13, color: Colors.grey.shade400),
            const SizedBox(width: 6),
            Text('Tus datos están seguros y encriptados.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Al pagar aceptas los ',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            const Text('Términos y Condiciones.',
                style: TextStyle(color: tealMain, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _bottomBtn(BuildContext context) {
    final label = esGratis ? 'Confirmar inscripción' : 'Pagar \$$total.00 MXN';
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: tealMain,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _cargando
              ? null
              : () async {
            setState(() => _cargando = true);
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => ConfirmacionPage(
                  torneo: t, total: total, metodoPago: _metodoPago ?? 'tarjeta',
                )),
              );
            }
          },
          child: _cargando
              ? const SizedBox(width: 20, height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      ),
    );
  }
}