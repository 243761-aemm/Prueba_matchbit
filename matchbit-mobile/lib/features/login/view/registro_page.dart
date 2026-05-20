import 'package:flutter/material.dart';
import 'package:taxis/core/user_session.dart';
import 'package:taxis/features/home/view/verificacion_page.dart';
import '../../login/widgets/custom_input.dart';
import '../../login/widgets/primary_button.dart';
import 'package:taxis/core/auth_service.dart';

class RegistroPage extends StatelessWidget {
  RegistroPage({super.key});

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
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
                "Únete a la comunidad",
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
                      "Crear cuenta",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Es gratis, rápido y seguro",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 28),

                    // Nombre y Apellido en fila
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Nombre"),
                              const SizedBox(height: 8),
                              CustomInput(
                                hint: "Carlos",
                                icon: Icons.person_outline,
                                controller: firstName,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Apellido"),
                              const SizedBox(height: 8),
                              CustomInput(
                                hint: "Mendez",
                                icon: Icons.person_outline,
                                controller: lastName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text("Correo electrónico"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "tu@correo.com",
                      icon: Icons.email_outlined,
                      controller: email,
                    ),

                    const SizedBox(height: 20),

                    const Text("Teléfono"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "+52 (999) 123-4567",
                      icon: Icons.phone_outlined,
                      controller: phone,
                    ),

                    const SizedBox(height: 20),

                    const Text("Contraseña"),
                    const SizedBox(height: 8),
                    CustomInput(
                      hint: "Mínimo 8 caracteres",
                      icon: Icons.lock_outline,
                      controller: password,
                      isPassword: true,
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: "Crear cuenta",
                      onPressed: () async {
                        final firstNameText = firstName.text.trim();
                        final lastNameText = lastName.text.trim();
                        final emailText = email.text.trim();
                        final passwordText = password.text.trim();
                        final phoneText = phone.text.trim();
                        final nameText = '$firstNameText $lastNameText'.trim();

                        if (firstNameText.isEmpty || emailText.isEmpty || passwordText.isEmpty) {
                          _showSnack(context, 'Por favor completa los campos obligatorios');
                          return;
                        }

                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(emailText)) {
                          _showSnack(context, 'Ingresa un correo electrónico válido');
                          return;
                        }

                        if (passwordText.length < 8) {
                          _showSnack(context, 'La contraseña debe tener al menos 8 caracteres');
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: Color(0xFF00D4A8)),
                          ),
                        );

                        final result = await AuthService.registro(
                          email: emailText,
                          password: passwordText,
                          whatsapp: phoneText.isEmpty ? '0000000000' : phoneText,
                        );

                        if (!context.mounted) return;
                        Navigator.pop(context);

                        if (result['success']) {
                          UserSession().login(
                            nombre: nameText,
                            email: emailText,
                          );
                          UserSession().telefono = phoneText;

                          final codigo = (1000 + (DateTime.now().millisecond % 9000)).toString();

                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerificacionPage(
                                telefono: phoneText,
                                codigoDemo: codigo,
                              ),
                            ),
                          );
                        } else {
                          _showSnack(
                            context,
                            result['message'] ?? 'Error al crear la cuenta',
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
                            text: "¿Ya tienes cuenta? ",
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