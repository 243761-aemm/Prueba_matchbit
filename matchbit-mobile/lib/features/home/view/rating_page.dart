// lib/features/home/view/rating_page.dart
//
// Bottom sheet con flujo completo de calificación:
//   Paso 1 → Estrellas (viaje + conductor) + conductor info
//   Paso 2 → Tags destacados + observaciones
//   Paso 3 → Pantalla de agradecimiento

import 'package:flutter/material.dart';
import 'package:taxis/core/viaje_model.dart';
import '../../../core/models/rating_model.dart';

class RatingPage extends StatefulWidget {
  final Viaje viaje;
  final VoidCallback? onCalificado;

  const RatingPage({
    super.key,
    required this.viaje,
    this.onCalificado,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage>
    with SingleTickerProviderStateMixin {
  // ── Colores ───────────────────────────────────────────────────────────────
  static const purpleMain  = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);
  static const purpleMid   = Color(0xFFE4DEFF);

  // ── Estado ────────────────────────────────────────────────────────────────
  int _paso = 1; // 1 = estrellas, 2 = tags, 3 = gracias

  int _estrellaViaje     = 0;
  int _estrellaConductor = 0;

  final List<String> _todosLosTagsConEmoji = [
    '⏱️ Puntual',
    '😊 Amable',
    '🚖 Unidad limpia',
    '❄️ A/C perfecto',
    '📶 WiFi rápido',
    '🗺️ Buen camino',
    '🔇 Silencioso',
    '💬 Trato excelente',
  ];
  final Set<String> _tagsSeleccionados = {};

  final TextEditingController _obsCtrl = TextEditingController();
  int _obsLen = 0;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  // Conductor ficticio (en prod vendrá del backend)
  static const _conductorNombre   = 'Roberto Jiménez';
  static const _conductorSubtitle = 'Conductor verificado APEX';

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.forward();
    _obsCtrl.addListener(() {
      setState(() => _obsLen = _obsCtrl.text.length);
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  // ── Navegación entre pasos ────────────────────────────────────────────────
  void _irPaso(int paso) {
    _animCtrl.reverse().then((_) {
      setState(() => _paso = paso);
      _animCtrl.forward();
    });
  }

  void _enviarCalificacion() {
    // Aquí puedes guardar en UserSession o enviar al backend
    final rating = RatingModel(
      viajeId: widget.viaje.codigo,
      estrellaViaje: _estrellaViaje,
      estrellaConductor: _estrellaConductor,
      destacados: _tagsSeleccionados.toList(),
      observaciones: _obsCtrl.text.trim(),
      fecha: DateTime.now(),
    );

    // TODO: RatingService.instance.guardar(rating);
    debugPrint('Rating guardado: $rating');

    _irPaso(3);
    widget.onCalificado?.call();
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _paso == 3 ? 0.55 : 0.90,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Handle bar
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _paso == 1
                    ? _buildPaso1(controller)
                    : _paso == 2
                    ? _buildPaso2(controller)
                    : _buildPaso3(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PASO 1: Estrellas ─────────────────────────────────────────────────────
  Widget _buildPaso1(ScrollController ctrl) {
    return ListView(
      controller: ctrl,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Califica tu viaje',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Color(0xFF1A1A2E))),
              Text(
                '${widget.viaje.codigo} · ${widget.viaje.destino}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ]),
            _closeBtn(context),
          ],
        ),

        const SizedBox(height: 20),

        // Card conductor
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: purpleLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: purpleMid),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: purpleMain,
              child: const Text('RJ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(_conductorNombre,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xFF1A1A2E))),
                    Text(_conductorSubtitle,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🚖',
                              style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(widget.viaje.unidad,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: purpleMain)),
                        ],
                      ),
                    ),
                  ]),
            ),
          ]),
        ),

        const SizedBox(height: 28),

        // Estrellas viaje
        _seccionEstrellas(
          titulo: '¿Cómo fue tu experiencia?',
          subtitulo: 'Califica el viaje en general',
          valor: _estrellaViaje,
          onChange: (v) => setState(() => _estrellaViaje = v),
        ),

        const SizedBox(height: 28),

        // Estrellas conductor
        _seccionEstrellas(
          titulo: '¿Cómo fue el conductor?',
          subtitulo: 'Puntualidad, trato y profesionalismo',
          valor: _estrellaConductor,
          onChange: (v) => setState(() => _estrellaConductor = v),
        ),

        const SizedBox(height: 32),

        // Botón siguiente
        _botonPrimario(
          label: 'Siguiente',
          enabled: _estrellaViaje > 0 && _estrellaConductor > 0,
          onTap: () => _irPaso(2),
        ),
      ],
    );
  }

  // ── PASO 2: Tags + Observaciones ──────────────────────────────────────────
  Widget _buildPaso2(ScrollController ctrl) {
    return ListView(
      controller: ctrl,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('¿Qué destacarías?',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Color(0xFF1A1A2E))),
              Text('Selecciona todo lo que aplique',
                  style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ]),
            _closeBtn(context),
          ],
        ),

        const SizedBox(height: 20),

        // Tags chips
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: _todosLosTagsConEmoji.map((tag) {
            final sel = _tagsSeleccionados.contains(tag);
            return GestureDetector(
              onTap: () => setState(() {
                sel
                    ? _tagsSeleccionados.remove(tag)
                    : _tagsSeleccionados.add(tag);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: sel ? purpleMain : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: sel ? purpleMain : const Color(0xFFE0E0E0),
                  ),
                  boxShadow: sel
                      ? [
                    BoxShadow(
                      color: purpleMain.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                      : [],
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: sel ? Colors.white : const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Observaciones
        Row(children: [
          const Text('Observaciones',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(width: 6),
          Text('(opcional)',
              style:
              TextStyle(color: Colors.grey.shade400, fontSize: 13)),
        ]),
        const SizedBox(height: 10),
        TextField(
          controller: _obsCtrl,
          maxLength: 300,
          maxLines: 4,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cuéntanos más sobre tu experiencia...',
            hintStyle:
            TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF7F8FC),
            counterText: '$_obsLen/300',
            counterStyle: TextStyle(
                color: Colors.grey.shade400, fontSize: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              const BorderSide(color: Color(0xFFEEEEEE)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              const BorderSide(color: Color(0xFFEEEEEE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              const BorderSide(color: purpleMain, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Botón enviar
        _botonPrimario(
          label: 'Enviar calificación',
          enabled: true,
          onTap: _enviarCalificacion,
        ),

        const SizedBox(height: 10),

        // Volver
        Center(
          child: GestureDetector(
            onTap: () => _irPaso(1),
            child: Text('← Volver',
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }

  // ── PASO 3: Gracias ───────────────────────────────────────────────────────
  Widget _buildPaso3(ScrollController ctrl) {
    return ListView(
      controller: ctrl,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      children: [
        const SizedBox(height: 16),
        const Center(
          child: Text('🏆', style: TextStyle(fontSize: 64)),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            '¡Gracias por calificar!',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Tu opinión nos ayuda a mejorar el\nservicio para futuros viajes.',
            textAlign: TextAlign.center,
            style:
            TextStyle(color: Colors.grey.shade500, fontSize: 14, height: 1.5),
          ),
        ),
        const SizedBox(height: 24),
        // Estrellas resumen
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _estrellaViaje,
                  (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text('⭐', style: TextStyle(fontSize: 30)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _botonPrimario(
          label: 'Listo',
          enabled: true,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // ── Widgets reutilizables ─────────────────────────────────────────────────

  Widget _seccionEstrellas({
    required String titulo,
    required String subtitulo,
    required int valor,
    required ValueChanged<int> onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF1A1A2E))),
        const SizedBox(height: 3),
        Text(subtitulo,
            style:
            TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final filled = i < valor;
            return GestureDetector(
              onTap: () => onChange(i + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    key: ValueKey('$i-$filled'),
                    color: filled
                        ? const Color(0xFFFFC107)
                        : Colors.grey.shade300,
                    size: 44,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            valor == 0
                ? 'Toca para calificar'
                : _labelEstrella(valor),
            style: TextStyle(
              color: valor == 0 ? Colors.grey.shade400 : purpleMain,
              fontSize: 13,
              fontWeight:
              valor == 0 ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _labelEstrella(int v) {
    switch (v) {
      case 1: return 'Muy malo 😞';
      case 2: return 'Regular 😐';
      case 3: return 'Bien 🙂';
      case 4: return 'Muy bien 😊';
      case 5: return 'Excelente 🌟';
      default: return '';
    }
  }

  Widget _botonPrimario({
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
              colors: [Color(0xFF8B6FF5), purpleMain])
              : null,
          color: enabled ? null : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
              ? [
            BoxShadow(
              color: purpleMain.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: enabled ? Colors.white : Colors.grey.shade400,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _closeBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.close_rounded,
            size: 18, color: Colors.grey),
      ),
    );
  }
}