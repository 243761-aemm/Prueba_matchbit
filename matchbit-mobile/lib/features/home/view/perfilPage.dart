import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  static const tealMain = Color(0xFF00C2A8);
  bool _modoOscuro = false;

  // Colores dinámicos según tema
  Color get bgColor => _modoOscuro ? const Color(0xFF0D1117) : const Color(0xFFF4F6F9);
  Color get cardColor => _modoOscuro ? const Color(0xFF161B22) : Colors.white;
  Color get textDark => _modoOscuro ? Colors.white : const Color(0xFF1A1F36);
  Color get textGray => _modoOscuro ? const Color(0xFF8B949E) : const Color(0xFF8A94A6);
  Color get dividerColor => _modoOscuro ? const Color(0xFF21262D) : const Color(0xFFF0F0F0);
  Color get headerBg => _modoOscuro ? const Color(0xFF0D1117) : const Color(0xFFF4F6F9);

  final Map<String, dynamic> usuario = {
    'nombre': 'Carlos Mendez',
    'username': '@carlosmendez',
    'ciudad': 'Tuxtla Gutiérrez',
    'partidos': 23,
    'torneos': 8,
    'rating': 4.8,
    'deportes': ['Tenis', 'Pádel'],
    'nivel': 'Intermedio',
    'iniciales': 'CM',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildProfileHeader(),
            _buildStats(),
            _buildDeportesTags(),
            const SizedBox(height: 16),
            _buildMenuSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: headerBg,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: tealMain, width: 3),
            ),
            child: CircleAvatar(
              backgroundColor: tealMain,
              child: Text(
                usuario['iniciales'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            usuario['nombre'],
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${usuario['username']} · ${usuario['ciudad']}',
            style: TextStyle(fontSize: 13, color: textGray),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      color: headerBg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _statItem('${usuario['partidos']}', 'Partidos'),
          _statDivider(),
          _statItem('${usuario['torneos']}', 'Torneos'),
          _statDivider(),
          _statItem('${usuario['rating']}', 'Rating'),
        ],
      ),
    );
  }

  Widget _statItem(String valor, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: tealMain,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: textGray),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(
      height: 30,
      width: 1,
      color: dividerColor,
    );
  }

  Widget _buildDeportesTags() {
    return Container(
      color: headerBg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Wrap(
        spacing: 8,
        children: [
          ...(usuario['deportes'] as List<String>).map((d) => _tag(d, tealMain)),
          _tag(usuario['nivel'], const Color(0xFFFF6B35)),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _menuItem(
          icon: Icons.calendar_today_rounded,
          iconColor: tealMain,
          title: 'Mis reservaciones',
          onTap: () {},
        ),
        _menuItem(
          icon: Icons.emoji_events_rounded,
          iconColor: const Color(0xFFFFC107),
          title: 'Mis torneos',
          onTap: () {},
        ),
        _menuItem(
          icon: Icons.bolt_rounded,
          iconColor: const Color(0xFFFF6B35),
          title: 'Mis retas',
          onTap: () {},
        ),
        _menuItem(
          icon: Icons.credit_card_rounded,
          iconColor: const Color(0xFF7C3AED),
          title: 'Métodos de pago',
          onTap: () {},
        ),
        // Modo oscuro con switch
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 2),
          decoration: BoxDecoration(
            color: cardColor,
            border: Border(
              bottom: BorderSide(color: dividerColor),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B5BD6).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.dark_mode_rounded,
                    color: Color(0xFF5B5BD6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Modo oscuro',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: textDark,
                    ),
                  ),
                ),
                Switch(
                  value: _modoOscuro,
                  onChanged: (v) => setState(() => _modoOscuro = v),
                  activeColor: tealMain,
                  activeTrackColor: tealMain.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
        _menuItem(
          icon: Icons.settings_rounded,
          iconColor: Colors.grey,
          title: 'Configuración',
          onTap: () {},
        ),
        _menuItem(
          icon: Icons.help_outline_rounded,
          iconColor: Colors.grey,
          title: 'Ayuda y soporte',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        // Cerrar sesión
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5252).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFFF5252).withOpacity(0.2)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded,
                      color: Color(0xFFFF5252), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Color(0xFFFF5252),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 2),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            bottom: BorderSide(color: dividerColor),
          ),
        ),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: textDark,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: textGray),
            ],
          ),
        ),
      ),
    );
  }
}