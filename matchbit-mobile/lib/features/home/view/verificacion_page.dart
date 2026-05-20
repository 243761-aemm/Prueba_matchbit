import 'package:flutter/material.dart';
import 'package:taxis/core/user_session.dart';
import 'onboarding_page.dart';

class VerificacionPage extends StatefulWidget {
  final String telefono;
  final String codigoDemo;

  const VerificacionPage({
    super.key,
    required this.telefono,
    required this.codigoDemo,
  });

  @override
  State<VerificacionPage> createState() => _VerificacionPageState();
}

class _VerificacionPageState extends State<VerificacionPage> {
  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);

  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _segundos = 28;
  bool _puedeReenviar = false;

  @override
  void initState() {
    super.initState();
    _iniciarContador();
  }

  void _iniciarContador() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_segundos > 0) {
        setState(() => _segundos--);
        _iniciarContador();
      } else {
        setState(() => _puedeReenviar = true);
      }
    });
  }

  String get _codigoIngresado =>
      _controllers.map((c) => c.text).join();

  String get _telefonoOculto {
    final t = widget.telefono;
    if (t.length <= 4) return t;
    return '${t.substring(0, 3)}${'•' * (t.length - 6)}${t.substring(t.length - 2)}';
  }

  void _verificar() {
    if (_codigoIngresado.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Ingresa el código completo'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    if (_codigoIngresado != widget.codigoDemo) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Código incorrecto, intenta de nuevo'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      for (var c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
      return;
    }

    // Código correcto → ir al onboarding
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 20)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Icono
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: purpleLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded,
                      color: purpleMain, size: 30),
                ),

                const SizedBox(height: 20),

                const Text('Verifica tu cuenta',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),

                const SizedBox(height: 8),

                Text(
                  'Enviamos un código de 4 dígitos a\n$_telefonoOculto',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.5),
                ),

                const SizedBox(height: 24),

                // Chip demo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFE599)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('', style: TextStyle(fontSize: 14)),
                      Text('Demo: el código es  ', style: TextStyle(color: Colors.orange.shade700, fontSize: 13)),
                      Text(widget.codigoDemo,
                          style: TextStyle(color: Colors.orange.shade700, fontSize: 13, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Campos OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    return Container(
                      width: 56, height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: purpleLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: purpleMain, width: 2),
                          ),
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && i < 3) {
                            _focusNodes[i + 1].requestFocus();
                          }
                          if (val.isEmpty && i > 0) {
                            _focusNodes[i - 1].requestFocus();
                          }
                          setState(() {});
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 28),

                // Botón verificar
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B6FF5), purpleMain],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _verificar,
                      child: const Text('Verificar código',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Reenviar
                GestureDetector(
                  onTap: _puedeReenviar ? () {
                    setState(() {
                      _segundos = 28;
                      _puedeReenviar = false;
                    });
                    _iniciarContador();
                  } : null,
                  child: Text(
                    _puedeReenviar
                        ? '¿No llegó el código? Reenviar'
                        : '¿No llegó el código? Reenviar en ${_segundos}s',
                    style: TextStyle(
                      color: _puedeReenviar ? purpleMain : Colors.grey.shade400,
                      fontSize: 13,
                      fontWeight: _puedeReenviar ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('← Volver al registro',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}