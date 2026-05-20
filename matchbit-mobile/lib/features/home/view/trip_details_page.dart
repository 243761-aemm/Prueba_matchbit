import 'package:flutter/material.dart';
import 'dart:math';
import '../../home/view/confirmation_page.dart';
import 'package:taxis/core/user_session.dart';
import 'package:taxis/core/viaje_model.dart';


class TripDetailsPage extends StatefulWidget {
  final String destino;
  final String km;
  final String unidad;
  final String precio;

  const TripDetailsPage({
    super.key,
    required this.destino,
    required this.km,
    required this.unidad,
    required this.precio,
  });

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);
  static const purpleMid = Color(0xFFE4DEFF);
  static const bgColor = Color(0xFFF7F8FC);

  String salidaTipo = 'ahora';
  String pagoTipo = '';

  final fechaCtrl = TextEditingController();
  final horaCtrl  = TextEditingController();
  final cardCtrl  = TextEditingController();
  final expCtrl   = TextEditingController();
  final cvvCtrl   = TextEditingController();

  @override
  void dispose() {
    fechaCtrl.dispose();
    horaCtrl.dispose();
    cardCtrl.dispose();
    expCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  bool get canConfirm => pagoTipo.isNotEmpty;

  String _generarCodigo() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return 'APEX-' + List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> _mostrarSelectorHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial, // 🕐 reloj circular
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: purpleMain,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hora = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minutos = picked.minute.toString().padLeft(2, '0');
      final periodo = picked.period == DayPeriod.am ? 'a.m.' : 'p.m.';

      setState(() {
        horaCtrl.text = '$hora:$minutos $periodo';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _stepProgress(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                children: [
                  _sectionTitle('Horario y pago', 'Últimos detalles de tu viaje'),
                  const SizedBox(height: 20),
                  _label('¿CUÁNDO SALES?'),
                  const SizedBox(height: 10),
                  _salidaSelector(),
                  if (salidaTipo == 'programar') ...[
                    const SizedBox(height: 12),
                    _dateTimeFields(),
                  ],
                  const SizedBox(height: 24),
                  _label('MÉTODO DE PAGO'),
                  const SizedBox(height: 10),
                  _pagoSelector(),
                  if (pagoTipo == 'tarjeta') ...[
                    const SizedBox(height: 12),
                    _cardFields(),
                  ],
                  const SizedBox(height: 24),
                  _resumen(),
                  const SizedBox(height: 16),
                  _confirmButton(),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text('← Cambiar unidad',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
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

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B6FF5), purpleMain],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: const Icon(Icons.local_taxi_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(text: 'APEX', style: TextStyle(color: purpleMain, fontWeight: FontWeight.w800, fontSize: 17, letterSpacing: 0.5)),
                    TextSpan(text: ' Transfer', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 17)),
                  ]),
                ),
              ]),
              CircleAvatar(
                backgroundColor: purpleMid,
                radius: 20,
                child: Text(
                  UserSession().inicial,
                  style: const TextStyle(color: purpleMain, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Buenas tardes, ${UserSession().nombre} 👋',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 5),
          RichText(
            text: const TextSpan(children: [
              TextSpan(text: '¿A dónde vas ', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              TextSpan(text: 'hoy?', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: purpleMain)),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: purpleLight,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: purpleMid),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.flight_land_rounded, color: purpleMain, size: 14),
                SizedBox(width: 6),
                Text('Aeropuerto Ángel Albino Corzo · TGZ',
                    style: TextStyle(color: purpleMain, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepProgress() {
    const steps = ['Destino', 'Unidad', 'Detalles', 'Listo'];
    const currentStep = 3;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final filled = (i ~/ 2) + 1 < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: filled ? purpleMain : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }
          final step = i ~/ 2 + 1;
          final active = step == currentStep;
          final done = step < currentStep;
          return Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: active || done ? purpleMain : const Color(0xFFEEEEEE),
                shape: BoxShape.circle,
                boxShadow: active ? [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))] : [],
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                    : Text('$step', style: TextStyle(
                    color: active ? Colors.white : Colors.black38,
                    fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 5),
            Text(steps[step - 1], style: TextStyle(
              fontSize: 11,
              color: active ? purpleMain : Colors.grey.shade400,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            )),
          ]);
        }),
      ),
    );
  }

  Widget _sectionTitle(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 3),
        Text(sub, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
      ],
    );
  }

  Widget _label(String text) {
    return Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.8));
  }

  Widget _salidaSelector() {
    return Row(children: [
      Expanded(child: _opcionCard(
        selected: salidaTipo == 'ahora',
        onTap: () => setState(() => salidaTipo = 'ahora'),
        icon: Icons.bolt_rounded,
        iconColor: const Color(0xFFFF8C00),
        label: 'Ahora',
        sub: 'Salida inmediata',
      )),
      const SizedBox(width: 12),
      Expanded(child: _opcionCard(
        selected: salidaTipo == 'programar',
        onTap: () => setState(() => salidaTipo = 'programar'),
        icon: Icons.calendar_month_rounded,
        iconColor: const Color(0xFF4C9EF1),
        label: 'Programar',
        sub: 'Elige fecha y hora',
      )),
    ]);
  }

  Widget _pagoSelector() {
    return Row(children: [
      Expanded(child: _opcionCard(
        selected: pagoTipo == 'tarjeta',
        onTap: () => setState(() => pagoTipo = 'tarjeta'),
        icon: Icons.credit_card_rounded,
        iconColor: const Color(0xFF4C9EF1),
        label: 'Tarjeta',
        sub: '',
      )),
      const SizedBox(width: 12),
      Expanded(child: _opcionCard(
        selected: pagoTipo == 'efectivo',
        onTap: () => setState(() => pagoTipo = 'efectivo'),
        icon: Icons.payments_rounded,
        iconColor: const Color(0xFF2ECC71),
        label: 'Efectivo',
        sub: '',
      )),
    ]);
  }

  Widget _opcionCard({
    required bool selected,
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String sub,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected ? purpleLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? purpleMain : const Color(0xFFF0F0F0), width: selected ? 2 : 1),
          boxShadow: selected
              ? [BoxShadow(color: purpleMain.withOpacity(0.10), blurRadius: 12, offset: const Offset(0, 4))]
              : [const BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A2E))),
          if (sub.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(sub, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ]
        ]),
      ),
    );
  }

  Widget _dateTimeFields() {
    return Row(children: [
      Expanded(child: _fechaPicker()),
      const SizedBox(width: 12),
      Expanded(child: _horaPicker()),
    ]);
  }

  Widget _fechaPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fecha', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final hoy = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: hoy,
              firstDate: hoy,
              lastDate: DateTime(hoy.year + 1),
              locale: const Locale('es', 'MX'),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: purpleMain,
                      onPrimary: Colors.white,
                      onSurface: Color(0xFF1A1A2E),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                fechaCtrl.text = '${picked.day}/${picked.month}/${picked.year}';
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: fechaCtrl.text.isEmpty ? const Color(0xFFF7F8FC) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: fechaCtrl.text.isEmpty ? const Color(0xFFEEEEEE) : purpleMain,
                width: fechaCtrl.text.isEmpty ? 1 : 1.5,
              ),
            ),
            child: Row(children: [
              Icon(Icons.calendar_today_rounded,
                  size: 16,
                  color: fechaCtrl.text.isEmpty ? Colors.grey.shade400 : purpleMain),
              const SizedBox(width: 8),
              Text(
                fechaCtrl.text.isEmpty ? 'dd/mm/aaaa' : fechaCtrl.text,
                style: TextStyle(
                  fontSize: 13,
                  color: fechaCtrl.text.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A2E),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _horaPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hora', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            if (fechaCtrl.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Primero selecciona una fecha'),
                  backgroundColor: purpleMain,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
              return;
            }
            await _mostrarSelectorHora();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: horaCtrl.text.isEmpty ? const Color(0xFFF7F8FC) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: horaCtrl.text.isEmpty ? const Color(0xFFEEEEEE) : purpleMain,
                width: horaCtrl.text.isEmpty ? 1 : 1.5,
              ),
            ),
            child: Row(children: [
              Icon(Icons.schedule_rounded,
                  size: 16,
                  color: horaCtrl.text.isEmpty ? Colors.grey.shade400 : purpleMain),
              const SizedBox(width: 8),
              Text(
                horaCtrl.text.isEmpty ? '--:-- ----' : horaCtrl.text,
                style: TextStyle(
                  fontSize: 13,
                  color: horaCtrl.text.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A2E),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _cardFields() {
    return Column(children: [
      _inputField(ctrl: cardCtrl, hint: '0000 0000 0000 0000', icon: Icons.credit_card_rounded, label: 'Número de tarjeta', keyboardType: TextInputType.number),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _inputField(ctrl: expCtrl, hint: 'MM/AA', icon: Icons.date_range_rounded, label: 'Vencimiento', keyboardType: TextInputType.datetime)),
        const SizedBox(width: 12),
        Expanded(child: _inputField(ctrl: cvvCtrl, hint: '•••', icon: Icons.lock_rounded, label: 'CVV', keyboardType: TextInputType.number, obscure: true)),
      ]),
    ]);
  }

  Widget _inputField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 18),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: purpleMain, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _resumen() {
    String pagoLabel = pagoTipo == 'tarjeta' ? '💳 Tarjeta' : pagoTipo == 'efectivo' ? '💵 Efectivo' : '—';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(children: [
        _resumenRow('Destino', widget.destino),
        _resumenDivider(),
        _resumenRow('Unidad', '🚕 ${widget.unidad}'),
        _resumenDivider(),
        _resumenRow('Pago', pagoLabel),
        _resumenDivider(),
        _resumenRow('Total', '${widget.precio} MXN', isTotal: true),
      ]),
    );
  }

  Widget _resumenRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? const Color(0xFF1A1A2E) : Colors.grey.shade600,
          )),
          Text(value, style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? purpleMain : const Color(0xFF1A1A2E),
          )),
        ],
      ),
    );
  }

  Widget _resumenDivider() => const Divider(height: 1, color: Color(0xFFF5F5F5), indent: 16, endIndent: 16);

  Widget _confirmButton() {
    return GestureDetector(
      onTap: canConfirm ? () async {
        final ahora = DateTime.now();
        final fechaStr = salidaTipo == 'programar' && fechaCtrl.text.isNotEmpty
            ? fechaCtrl.text
            : '${ahora.day}/${ahora.month}/${ahora.year}';
        final horaStr = salidaTipo == 'programar' && horaCtrl.text.isNotEmpty
            ? horaCtrl.text
            : () {
          final hora = ahora.hour > 12 ? ahora.hour - 12 : ahora.hour == 0 ? 12 : ahora.hour;
          final minutos = ahora.minute.toString().padLeft(2, '0');
          final periodo = ahora.hour >= 12 ? 'p.m.' : 'a.m.';
          return '$hora:$minutos $periodo';
        }();

        UserSession().viajes.insert(0, Viaje(
          destino: widget.destino,
          unidad: widget.unidad,
          pago: pagoTipo == 'tarjeta' ? 'Tarjeta' : 'Efectivo',
          precio: widget.precio,
          codigo: _generarCodigo(),
          fecha: fechaStr,
          hora: horaStr,
          tipo: salidaTipo == 'ahora' ? 'Inmediato' : 'Programado',
          estado: 'en_camino',
        ));

        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white,
          builder: (_) => const _LoadingOverlay(),
        );

        await Future.delayed(const Duration(milliseconds: 2500));

        if (!context.mounted) return;
        Navigator.pop(context);

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => ConfirmationPage(
              destino: widget.destino,
              unidad: widget.unidad,
              precio: widget.precio,
              pago: pagoTipo == 'tarjeta' ? 'Tarjeta' : 'Efectivo',
              salida: salidaTipo,
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: canConfirm
              ? const LinearGradient(colors: [Color(0xFF8B6FF5), purpleMain])
              : null,
          color: canConfirm ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          boxShadow: canConfirm
              ? [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 5))]
              : [],
        ),
        child: Center(
          child: Text(
            canConfirm ? 'Confirmar reservación →' : 'Selecciona método de pago',
            style: TextStyle(
              color: canConfirm ? Colors.white : Colors.grey.shade400,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: purpleMain,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.luggage_rounded), label: 'Viajes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _LoadingOverlay extends StatefulWidget {
  const _LoadingOverlay();

  @override
  State<_LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<_LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);

  int _fase = 0;

  final _mensajes = [
    'Buscando conductor...',
    'Confirmando reservación...',
    '¡Todo listo! 🎉',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _fadeAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _fase = 1);
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _fase = 2);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B6DFF), purpleMain],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Icon(
                    _fase == 2 ? Icons.check_rounded : Icons.local_taxi_rounded,
                    color: Colors.white, size: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final active = i == _fase;
                final done = i < _fase;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active || done ? purpleMain : purpleLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                _mensajes[_fase],
                key: ValueKey(_fase),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
              ),
            ),
            const SizedBox(height: 8),
            Text('APEX Transfer',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}