import 'package:flutter/material.dart';
import 'package:taxis/features/home/view/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  // ── Colores ─────────────────────────────────────────────
  static const tealMain  = Color(0xFF00C2A8);
  static const tealDark  = Color(0xFF009E88);
  static const bgColor   = Color(0xFFF4F6F9);
  static const cardColor = Colors.white;
  static const textDark  = Color(0xFF1A1F36);
  static const textMuted = Color(0xFF8A94A6);

  // ── Estado ──────────────────────────────────────────────
  int _step = 0; // 0 = deportes, 1 = nivel, 2 = ubicación
  final Set<String> _deportesSeleccionados = {};
  String? _nivelSeleccionado;
  bool _usarUbicacion = false;
  final TextEditingController _ciudadController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  // ── Data ────────────────────────────────────────────────
  final _deportes = [
    {'nombre': 'Tenis',     'emoji': '🎾'},
    {'nombre': 'Pádel',     'emoji': '🏓'},
    {'nombre': 'Fútbol',    'emoji': '⚽'},
    {'nombre': 'Gym',       'emoji': '🏋️'},
    {'nombre': 'Natación',  'emoji': '🏊'},
    {'nombre': 'Voleibol',  'emoji': '🏐'},
    {'nombre': 'Ciclismo',  'emoji': '🚴'},
    {'nombre': 'Running',   'emoji': '🏃'},
    {'nombre': 'Bádminton', 'emoji': '🏸'},
  ];

  final _niveles = [
    {'id': 'principiante', 'label': 'Principiante', 'sub': 'Estoy aprendiendo',    'emoji': '🌱'},
    {'id': 'intermedio',   'label': 'Intermedio',   'sub': 'Juego regularmente',    'emoji': '⚡'},
    {'id': 'avanzado',     'label': 'Avanzado',     'sub': 'Compito en torneos',    'emoji': '🔥'},
    {'id': 'elite',        'label': 'Élite',        'sub': 'Nivel profesional',      'emoji': '🏆'},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    _fadeController.reverse().then((_) {
      setState(() => _step = step);
      _fadeController.forward();
    });
  }

  void _siguiente() {
    if (_step == 0 && _deportesSeleccionados.isNotEmpty) _goTo(1);
    else if (_step == 1 && _nivelSeleccionado != null) _goTo(2);
    else if (_step == 2) _irAlHome();
  }

  void _atras() {
    if (_step > 0) _goTo(_step - 1);
  }

  void _irAlHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
    );
  }

  bool get _puedeAvanzar {
    if (_step == 0) return _deportesSeleccionados.isNotEmpty;
    if (_step == 1) return _nivelSeleccionado != null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              _topBar(),
              _progressBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                  child: _buildStep(),
                ),
              ),
              _bottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ── TOP BAR ─────────────────────────────────────────────
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [tealMain, tealDark]),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.sports_tennis_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text('MatchBit',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: textDark, letterSpacing: -0.5)),
          ]),
          // Omitir
          GestureDetector(
            onTap: _irAlHome,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(children: const [
                Text('Omitir', style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 13, color: textMuted),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── PROGRESS BAR ────────────────────────────────────────
  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < _step;
          final active = i == _step;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: done || active ? tealMain : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: done
                  ? null
                  : active
                  ? FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [tealMain, tealDark]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
                  : null,
            ),
          );
        }),
      ),
    );
  }

  // ── STEP BUILDER ────────────────────────────────────────
  Widget _buildStep() {
    switch (_step) {
      case 0: return _stepDeportes();
      case 1: return _stepNivel();
      case 2: return _stepUbicacion();
      default: return const SizedBox();
    }
  }

  // ── STEP HEADER ─────────────────────────────────────────
  Widget _stepHeader(String linea1, String linea2, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(text: '$linea1\n',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textDark, height: 1.15)),
            TextSpan(text: linea2,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: tealMain, height: 1.15)),
          ]),
        ),
        const SizedBox(height: 6),
        Text(sub, style: const TextStyle(color: textMuted, fontSize: 13)),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── PASO 1: DEPORTES ─────────────────────────────────────
  Widget _stepDeportes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader('¿Qué deportes', 'te apasionan?', 'Selecciona todos los que quieras'),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _deportes.map((d) {
            final nombre = d['nombre'] as String;
            final selected = _deportesSeleccionados.contains(nombre);
            return GestureDetector(
              onTap: () => setState(() {
                if (selected) _deportesSeleccionados.remove(nombre);
                else _deportesSeleccionados.add(nombre);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFE8FAF7) : cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? tealMain : Colors.grey.shade200,
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(selected ? 0.0 : 0.04),
                      blurRadius: 8, offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(d['emoji'] as String, style: const TextStyle(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected ? tealMain : textDark,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (_deportesSeleccionados.isNotEmpty) ...[
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${_deportesSeleccionados.length} seleccionado${_deportesSeleccionados.length > 1 ? 's' : ''}',
              style: const TextStyle(color: tealMain, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }

  // ── PASO 2: NIVEL ────────────────────────────────────────
  Widget _stepNivel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader('¿Cuál es tu', 'nivel de juego?', 'Te conectaremos con rivales ideales'),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _niveles.map((n) {
            final id = n['id'] as String;
            final selected = _nivelSeleccionado == id;
            return GestureDetector(
              onTap: () => setState(() => _nivelSeleccionado = id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFE8FAF7) : cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? tealMain : Colors.grey.shade200,
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8, offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(n['emoji'] as String, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            n['label'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: selected ? tealMain : textDark,
                            ),
                          ),
                          Text(
                            n['sub'] as String,
                            style: const TextStyle(fontSize: 11, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle_rounded, color: tealMain, size: 18),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── PASO 3: UBICACIÓN ────────────────────────────────────
  Widget _stepUbicacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader('¿Dónde', 'juegas?', 'Encontraremos los mejores clubes cerca de ti'),

        // Opción ubicación actual
        GestureDetector(
          onTap: () => setState(() {
            _usarUbicacion = true;
            _ciudadController.clear();
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _usarUbicacion ? const Color(0xFFE8FAF7) : cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _usarUbicacion ? tealMain : Colors.grey.shade200,
                width: _usarUbicacion ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: _usarUbicacion ? tealMain.withOpacity(0.15) : const Color(0xFFF4F6F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.my_location_rounded,
                      color: _usarUbicacion ? tealMain : textMuted, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Usar mi ubicación actual',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _usarUbicacion ? tealMain : textDark,
                          )),
                      const Text('Tuxtla Gutiérrez, Chiapas',
                          style: TextStyle(color: textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                if (_usarUbicacion)
                  const Icon(Icons.check_circle_rounded, color: tealMain, size: 20),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Divisor
        Row(children: [
          Expanded(child: Divider(color: Colors.grey.shade200)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('O busca tu ciudad',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Divider(color: Colors.grey.shade200)),
        ]),

        const SizedBox(height: 20),

        // Campo de texto
        GestureDetector(
          onTap: () => setState(() => _usarUbicacion = false),
          child: TextField(
            controller: _ciudadController,
            onChanged: (_) => setState(() => _usarUbicacion = false),
            style: const TextStyle(color: textDark, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Ingresa tu ciudad...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
              filled: true,
              fillColor: cardColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: tealMain, width: 1.5),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Resumen de lo que eligieron
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tealMain.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.auto_awesome_rounded, color: tealMain, size: 15),
                SizedBox(width: 6),
                Text('Tu perfil', style: TextStyle(color: tealMain, fontSize: 12, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: [
                  ..._deportesSeleccionados.take(4).map((d) => _chip(d)),
                  if (_deportesSeleccionados.length > 4)
                    _chip('+${_deportesSeleccionados.length - 4} más'),
                  if (_nivelSeleccionado != null)
                    _chip(_niveles.firstWhere((n) => n['id'] == _nivelSeleccionado)['label'] as String,
                        isNivel: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, {bool isNivel = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isNivel ? tealMain.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tealMain.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isNivel ? tealDark : textDark,
        ),
      ),
    );
  }

  // ── BOTTOM BUTTONS ───────────────────────────────────────
  Widget _bottomButtons() {
    final labels = ['Continuar', 'Continuar', '¡Empezar!'];
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón principal
          SizedBox(
            width: double.infinity,
            child: AnimatedOpacity(
              opacity: _puedeAvanzar ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tealMain,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _puedeAvanzar ? _siguiente : null,
                child: Text(
                  labels[_step],
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ),
          // Atrás (desde paso 1 en adelante)
          if (_step > 0) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: textMuted,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                onPressed: _atras,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 16),
                    SizedBox(width: 6),
                    Text('Atrás', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}