import 'package:flutter/material.dart';
import 'package:taxis/core/auth_service.dart';
import '../../login/widgets/custom_input.dart';
import '../../login/widgets/primary_button.dart';
import '../../login/view/login_page.dart';

class NuevaPasswordPage extends StatelessWidget {
  final String email;
  final String code;

  NuevaPasswordPage({super.key, required this.email, required this.code});

  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

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
              // Logo
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
                    // Ícono
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4A8).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_open_rounded,
                        color: Color(0xFF00D4A8),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Nueva contraseña",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Crea una contraseña segura de al menos 6 caracteres.",
                      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 28),

                    const Text("Nueva contraseña"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "••••••••",
                      icon: Icons.lock_outline,
                      controller: newPassword,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),

                    const Text("Confirmar contraseña"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "••••••••",
                      icon: Icons.lock_outline,
                      controller: confirmPassword,
                      isPassword: true,
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: "Actualizar contraseña",
                      onPressed: () async {
                        final newPass = newPassword.text.trim();
                        final confirmPass = confirmPassword.text.trim();

                        if (newPass.isEmpty || confirmPass.isEmpty) {
                          _showSnack(context, 'Por favor completa todos los campos');
                          return;
                        }

                        if (newPass.length < 6) {
                          _showSnack(context, 'La contraseña debe tener al menos 6 caracteres');
                          return;
                        }

                        if (newPass != confirmPass) {
                          _showSnack(context, 'Las contraseñas no coinciden', isError: true);
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: Color(0xFF00D4A8)),
                          ),
                        );

                        final result = await AuthService.resetPassword(
                          email: email,
                          code: code,
                          newPassword: newPass,
                        );

                        if (!context.mounted) return;
                        Navigator.pop(context); // Cerrar loading

                        if (result['success']) {
                          _showSuccess(context);
                        } else {
                          _showSnack(
                            context,
                            result['message'] ?? 'Error al actualizar la contraseña',
                            isError: true,
                          );
                        }
                      },
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

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFF00D4A8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                "¡Contraseña actualizada!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Tu contraseña fue restablecida exitosamente. Ahora puedes iniciar sesión.",
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Ir al inicio de sesión",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
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