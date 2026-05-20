import 'package:flutter/material.dart';
import 'package:taxis/core/auth_service.dart';
import '../../login/widgets/custom_input.dart';
import '../../login/widgets/primary_button.dart';
import 'verificar_codigo_page.dart';

class OlvidePasswordPage extends StatelessWidget {
  OlvidePasswordPage({super.key});

  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
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

              // Card
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
                    // Ícono superior
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4A8).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: Color(0xFF00D4A8),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Ingresa tu correo electrónico y te enviaremos un código de verificación para restablecer tu contraseña.",
                      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 28),

                    const Text("Correo electrónico"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "tu@correo.com",
                      icon: Icons.email_outlined,
                      controller: email,
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: "Enviar código",
                      onPressed: () async {
                        final emailText = email.text.trim();

                        if (emailText.isEmpty) {
                          _showSnack(context, 'Por favor ingresa tu correo electrónico');
                          return;
                        }

                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(emailText)) {
                          _showSnack(context, 'Ingresa un correo electrónico válido');
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: Color(0xFF00D4A8)),
                          ),
                        );

                        final result = await AuthService.sendPasswordResetCode(email: emailText);

                        if (!context.mounted) return;
                        Navigator.pop(context); // Cerrar loading

                        if (result['success']) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerificarCodigoPage(email: emailText),
                            ),
                          );
                        } else {
                          _showSnack(
                            context,
                            result['message'] ?? 'Error al enviar el código',
                            isError: true,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text.rich(
                          TextSpan(
                            text: "¿Recuerdas tu contraseña? ",
                            children: [
                              TextSpan(
                                text: "Inicia sesión",
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