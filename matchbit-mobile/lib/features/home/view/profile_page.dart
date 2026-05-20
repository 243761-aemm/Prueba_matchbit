import 'package:flutter/material.dart';
import '../../login/view/login_page.dart';
import 'trips_page.dart';
import '../../../core/user_session.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);
  static const purpleMid = Color(0xFFE4DEFF);
  static const bgColor = Color(0xFFF7F8FC);

  late TextEditingController nombreCtrl;
  late TextEditingController telefonoCtrl;

  bool _editando = false;
  bool _guardado = false;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: UserSession().nombre);
    telefonoCtrl = TextEditingController(text: UserSession().telefono);
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    telefonoCtrl.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    // Actualizar sesión con los nuevos datos
    UserSession().nombre = nombreCtrl.text.trim();
    UserSession().telefono = telefonoCtrl.text.trim();

    setState(() {
      _editando = false;
      _guardado = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _guardado = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: _bottomNav(context),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _avatarSection(),
                  const SizedBox(height: 16),
                  _statsRow(),
                  const SizedBox(height: 20),
                  _datosPersonales(),
                  const SizedBox(height: 20),
                  _sesionSection(context),
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
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
              TextSpan(text: 'Mi ', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w800, fontSize: 17)),
              TextSpan(text: 'Perfil', style: TextStyle(color: purpleMain, fontWeight: FontWeight.w800, fontSize: 17)),
            ]),
          ),
        ],
      ),
    );
  }

  // ── AVATAR ── aquí están los cambios
  Widget _avatarSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: purpleMid,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: purpleMain.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Center(
              child: Text(
                UserSession().inicial, // ← aquí el cambio
                style: const TextStyle(color: purpleMain, fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            UserSession().nombre, // ← aquí
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 4),
          Text(
            UserSession().email, // ← aquí
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Expanded(child: _statItem('1', 'VIAJES')),
          _statDivider(),
          Expanded(child: _statItem('0', 'EJECUTIVO')),
          _statDivider(),
          Expanded(child: _statItem('1', 'PREMIUM')),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: purpleMain)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _statDivider() => Container(width: 1, height: 40, color: const Color(0xFFF0F0F0));

  Widget _datosPersonales() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Datos personales',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
              GestureDetector(
                onTap: () => setState(() => _editando = !_editando),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _editando ? const Color(0xFFFFEEEE) : purpleLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(children: [
                    Icon(
                      _editando ? Icons.close_rounded : Icons.edit_rounded,
                      size: 13,
                      color: _editando ? Colors.red.shade400 : purpleMain,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _editando ? 'Cancelar' : 'Editar',
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: _editando ? Colors.red.shade400 : purpleMain,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _campoLabel('Nombre completo'),
          const SizedBox(height: 6),
          _campoInput(ctrl: nombreCtrl, hint: 'Tu nombre', enabled: _editando),

          const SizedBox(height: 16),

          _campoLabel('Teléfono'),
          const SizedBox(height: 6),
          _campoInput(
            ctrl: telefonoCtrl,
            hint: '+52 000 000 0000',
            enabled: _editando,
            keyboardType: TextInputType.phone,
          ),

          if (_editando) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _guardarCambios,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF8B6FF5), purpleMain]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Center(
                  child: Text('Guardar cambios',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ),
          ],

          if (_guardado) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB7EBD4)),
              ),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF2ECC71), size: 18),
                const SizedBox(width: 8),
                const Text('Datos actualizados correctamente',
                    style: TextStyle(color: Color(0xFF27AE60), fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _campoLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600));
  }

  Widget _campoInput({
    required TextEditingController ctrl,
    required String hint,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: enabled ? purpleMain : const Color(0xFFEEEEEE), width: enabled ? 1.5 : 1),
      ),
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: InputBorder.none,
          suffixIcon: enabled
              ? const Icon(Icons.edit_rounded, size: 16, color: purpleMain)
              : null,
        ),
      ),
    );
  }

  Widget _sesionSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sesión',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('¿Cerrar sesión?',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  content: const Text('¿Estás seguro que deseas cerrar tu sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    TextButton(
                      onPressed: () {
                        UserSession().logout(); // ← limpiar sesión
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false,
                        );
                      },
                      child: const Text('Cerrar sesión',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFD5D5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 18),
                  const SizedBox(width: 8),
                  Text('Cerrar sesión',
                      style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w700, fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: purpleMain,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (i) {
          if (i == 0) Navigator.of(context).popUntil((route) => route.isFirst);
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TripsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.luggage_rounded), label: 'Viajes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}