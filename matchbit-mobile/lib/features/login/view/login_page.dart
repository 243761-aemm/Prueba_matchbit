import 'package:flutter/material.dart';
import 'package:taxis/core/user_session.dart';
import 'package:taxis/features/home/view/home_page.dart';
import '../../login/widgets/custom_input.dart';
import '../../login/widgets/primary_button.dart';
import '../../login/view/registro_page.dart';
import 'package:taxis/core/auth_service.dart';

import 'olvide_password_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Logo Matchbit
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4A8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "M",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "matchbit",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Tu comunidad deportiva favorita",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 32),

              // Card formulario
              Container(
                width: 380,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 20,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bienvenido 👋",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Inicia sesión para continuar",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 28),

                    const Text("Correo electrónico"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "tu@correo.com",
                      icon: Icons.email_outlined,
                      controller: email,
                    ),

                    const SizedBox(height: 20),

                    const Text("Contraseña"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "••••••••",
                      icon: Icons.lock_outline,
                      controller: password,
                      isPassword: true,
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: "Iniciar sesión",
                      onPressed: () async {
                        final emailText = email.text.trim();
                        final passwordText = password.text.trim();

                        if (emailText.isEmpty || passwordText.isEmpty) {
                          _showSnack(context, 'Por favor completa todos los campos');
                          return;
                        }

                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(emailText)) {
                          _showSnack(context, 'Ingresa un correo electrónico válido');
                          return;
                        }

                        if (passwordText.length < 6) {
                          _showSnack(context, 'La contraseña debe tener al menos 6 caracteres');
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: Color(0xFF00D4A8)),
                          ),
                        );

                        final result = await AuthService.login(
                          email: emailText,
                          password: passwordText,
                        );

                        if (!context.mounted) return;
                        Navigator.pop(context);

                        if (result['success']) {
                          final data = result['data'];
                          UserSession().login(
                            nombre: data['user']?['name'] ?? emailText.split('@')[0],
                            email: emailText,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        } else {
                          _showSnack(
                            context,
                            result['message'] ?? 'Error al iniciar sesión',
                            isError: true,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => OlvidePasswordPage()),
                        ),
                        child: const Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(color: Color(0xFF00D4A8), fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divisor
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "o continúa con",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegistroPage()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "¿No tienes cuenta? ",
                            children: [
                              TextSpan(
                                text: "Regístrate gratis",
                                style: TextStyle(
                                  color: Color(0xFF00D4A8),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade400 : const Color(0xFF00D4A8),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }
}

// ─── Botón social ──────────────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    this.icon,
    this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 18)),
            if (icon != null) Icon(icon, color: Colors.black87, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}