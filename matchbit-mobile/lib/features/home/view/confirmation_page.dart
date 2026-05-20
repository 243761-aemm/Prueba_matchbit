import 'package:flutter/material.dart';
import 'package:taxis/features/home/view/trips_page.dart';
import 'dart:math';

class ConfirmationPage extends StatelessWidget {
  final String destino;
  final String unidad;
  final String precio;
  final String pago;
  final String salida;

  const ConfirmationPage({
    super.key,
    required this.destino,
    required this.unidad,
    required this.precio,
    required this.pago,
    required this.salida,
  });

  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);
  static const purpleMid = Color(0xFFE4DEFF);
  static const bgColor = Color(0xFFF7F8FC);

  String _generarCodigo() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return 'APEX-' + List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final codigo = _generarCodigo();
    final fechaHora = _fechaHoraActual();

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
                  _heroBanner(codigo),
                  const SizedBox(height: 20),
                  _resumen(fechaHora),
                  const SizedBox(height: 16),
                  _notificacionBox(),
                  const SizedBox(height: 20),
                  _botonNuevaReservacion(context),
                  const SizedBox(height: 12),
                  _botonVerViajes(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HERO BANNER ──────────────────────────────────────────
  Widget _heroBanner(String codigo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9B6DFF), Color(0xFF6C4CF1), Color(0xFF5B3FD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: purpleMain.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 42)),
          const SizedBox(height: 16),
          const Text(
            'RESERVACIÓN CONFIRMADA',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            codigo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu solicitud fue enviada con éxito',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ── RESUMEN ──────────────────────────────────────────────
  Widget _resumen(String fechaHora) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(children: [
        _resumenRow('📍 Destino', destino),
        _resumenDivider(),
        _resumenRow('🚕 Unidad', unidad),
        _resumenDivider(),
        _resumenRow('📅 Fecha / Hora', fechaHora),
        _resumenDivider(),
        _resumenRow('💳 Pago', pago),
        _resumenDivider(),
        _resumenRow('Total', '$precio MXN', isTotal: true),
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

  Widget _resumenDivider() =>
      const Divider(height: 1, color: Color(0xFFF5F5F5), indent: 16, endIndent: 16);

  // ── NOTIFICACIÓN ─────────────────────────────────────────
  Widget _notificacionBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE599)),
      ),
      child: Row(children: [
        const Text('🟠', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Te notificaremos cuando un conductor tome tu viaje y cuando esté en camino al aeropuerto.',
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ]),
    );
  }

  // ── BOTONES ──────────────────────────────────────────────
  Widget _botonNuevaReservacion(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B6FF5), purpleMain],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: purpleMain.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: const Center(
          child: Text(
            'Nueva reservación',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonVerViajes(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const TripsPage()),
              (route) => route.isFirst,
        );
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: purpleLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: purpleMid),
        ),
        child: const Center(
          child: Text(
            'Ver mis viajes',
            style: TextStyle(
              color: purpleMain,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
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
            child: const Text('C', style: TextStyle(color: purpleMain, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // ── STEP PROGRESS ────────────────────────────────────────
  Widget _stepProgress() {
    const steps = ['Destino', 'Unidad', 'Detalles', 'Listo'];
    const currentStep = 4;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: purpleMain,
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
                boxShadow: active
                    ? [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]
                    : [],
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

  // ── BOTTOM NAV ───────────────────────────────────────────
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

  // ── HELPERS ──────────────────────────────────────────────
  String _fechaHoraActual() {
    final now = DateTime.now();
    final hora = now.hour > 12 ? now.hour - 12 : now.hour;
    final minutos = now.minute.toString().padLeft(2, '0');
    final periodo = now.hour >= 12 ? 'p.m.' : 'a.m.';
    return '${now.day}/${now.month}/${now.year} $hora:$minutos $periodo';
  }
}