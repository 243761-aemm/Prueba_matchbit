import 'package:flutter/material.dart';
import 'package:taxis/core/user_session.dart';
import 'package:taxis/core/viaje_model.dart';
import 'package:taxis/features/home/view/profile_page.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);
  static const purpleMid = Color(0xFFE4DEFF);
  static const bgColor = Color(0xFFF7F8FC);

  List<Viaje> get viajes => UserSession().viajes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: _bottomNav(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            Expanded(
              child: viajes.isEmpty
                  ? _emptyState()
                  : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: viajes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _viajeCard(context, viajes[index], index);
                },
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
              TextSpan(text: 'Mis ', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w800, fontSize: 17)),
              TextSpan(text: 'Viajes', style: TextStyle(color: purpleMain, fontWeight: FontWeight.w800, fontSize: 17)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _viajeCard(BuildContext context, Viaje viaje, int index) {
    Color estadoColor;
    String estadoLabel;

    switch (viaje.estado) {
      case 'en_camino':
        estadoColor = const Color(0xFF2ECC71);
        estadoLabel = 'En camino';
        break;
      case 'en_curso':
        estadoColor = const Color(0xFFFF8C00);
        estadoLabel = 'En curso';
        break;
      case 'cancelado':
        estadoColor = Colors.red.shade400;
        estadoLabel = 'Cancelado';
        break;
      default:
        estadoColor = Colors.grey.shade400;
        estadoLabel = 'Completado';
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _mostrarDetalle(context, viaje, index),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(viaje.destino,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1A2E))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: estadoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: estadoColor.withOpacity(0.3)),
                    ),
                    child: Row(children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(color: estadoColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Text(estadoLabel,
                          style: TextStyle(color: estadoColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  _chip('📅', viaje.fecha),
                  _chip('🕐', viaje.hora),
                  _chip('🚕', viaje.unidad),
                  _chip('💵', viaje.pago),
                ],
              ),
              const Divider(height: 20, color: Color(0xFFF5F5F5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(viaje.codigo,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500)),
                  Row(children: [
                    Text('${viaje.precio} MXN',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
                    const SizedBox(width: 10),
                    Text('Ver →',
                        style: TextStyle(color: purpleMain, fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String emoji, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: purpleLight, shape: BoxShape.circle),
            child: const Icon(Icons.luggage_rounded, color: purpleMain, size: 36),
          ),
          const SizedBox(height: 20),
          const Text('Sin viajes aún',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 6),
          Text('Tus reservaciones aparecerán aquí',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }

  void _mostrarDetalle(BuildContext context, Viaje viaje, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetalleModal(
        viaje: viaje,
        onCancelar: () => _cancelarViaje(context, viaje, index),
        onReagendar: () => _reagendarViaje(context, viaje, index), // ← agregado
      ),
    );
  }

  // ── REAGENDAR ────────────────────────────────────────────
  void _reagendarViaje(BuildContext context, Viaje viaje, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReagendarModal(
        viaje: viaje,
        onConfirmar: (nuevaFecha, nuevaHora) {
          setState(() {
            UserSession().viajes[index] = Viaje(
              destino: viaje.destino,
              unidad: viaje.unidad,
              pago: viaje.pago,
              precio: viaje.precio,
              codigo: viaje.codigo,
              fecha: nuevaFecha,
              hora: nuevaHora,
              tipo: 'Programado',
              estado: viaje.estado,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Viaje reagendado',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text('${viaje.codigo} · $nuevaFecha $nuevaHora',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ]),
              backgroundColor: const Color(0xFF1A1A2E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }

  void _cancelarViaje(BuildContext context, Viaje viaje, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                child: Icon(Icons.cancel_outlined, color: Colors.red.shade400, size: 28),
              ),
              const SizedBox(height: 16),
              const Text('¿Cancelar reservación?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: 'Esta acción no se puede deshacer. Tu reservación ',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.5),
                  children: [
                    TextSpan(text: viaje.codigo,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                    const TextSpan(text: ' será cancelada de inmediato.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      UserSession().viajes[index] = Viaje(
                        destino: viaje.destino,
                        unidad: viaje.unidad,
                        pago: viaje.pago,
                        precio: viaje.precio,
                        codigo: viaje.codigo,
                        fecha: viaje.fecha,
                        hora: viaje.hora,
                        tipo: viaje.tipo,
                        estado: 'cancelado',
                      );
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(children: [
                          const Icon(Icons.cancel_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Reservación cancelada',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                Text('Tu viaje ${viaje.codigo} fue cancelado',
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ]),
                        backgroundColor: const Color(0xFF1A1A2E),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Text('Sí, cancelar reservación',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEEEEEE)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mantener reservación',
                      style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
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
        currentIndex: 1,
        selectedItemColor: purpleMain,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (i) {
          if (i == 0) Navigator.of(context).popUntil((route) => route.isFirst);
          if (i == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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

// ── REAGENDAR MODAL ──────────────────────────────────────
class _ReagendarModal extends StatefulWidget {
  final Viaje viaje;
  final Function(String fecha, String hora) onConfirmar;

  const _ReagendarModal({required this.viaje, required this.onConfirmar});

  @override
  State<_ReagendarModal> createState() => _ReagendarModalState();
}

class _ReagendarModalState extends State<_ReagendarModal> {
  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);

  String _opcionFecha = '';
  String _nuevaFecha = '';
  String _nuevaHora = '';

  DateTime get _hoy => DateTime.now();
  DateTime get _manana => DateTime.now().add(const Duration(days: 1));

  String _formatFecha(DateTime d) => '${d.day}/${d.month}/${d.year}';

  String _formatDiaLabel(DateTime d) {
    const dias = ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
    const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${dias[d.weekday - 1]} ${d.day} de ${meses[d.month - 1]}';
  }

  bool get _puedeConfirmar => _opcionFecha.isNotEmpty && _nuevaHora.isNotEmpty;

  String get _resumenFechaHora {
    if (_nuevaFecha.isEmpty || _nuevaHora.isEmpty) return '';
    const dias = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    final partes = _nuevaFecha.split('/');
    final d = DateTime(int.parse(partes[2]), int.parse(partes[1]), int.parse(partes[0]));
    return '${dias[d.weekday - 1].substring(0, 1).toUpperCase()}${dias[d.weekday - 1].substring(1)}, ${d.day} de ${meses[d.month - 1]} · $_nuevaHora hrs';
  }

  Future<void> _seleccionarHora() async {
    int horaSeleccionada = 12;
    int minSeleccionado = 0;
    String periodoSeleccionado = 'a.m.';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Selecciona una hora',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => setStateDialog(() =>
                    horaSeleccionada = horaSeleccionada == 12 ? 1 : horaSeleccionada + 1),
                    icon: const Icon(Icons.keyboard_arrow_up_rounded, color: purpleMain),
                  ),
                  Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(color: purpleMain, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$horaSeleccionada',
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setStateDialog(() =>
                    horaSeleccionada = horaSeleccionada == 1 ? 12 : horaSeleccionada - 1),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: purpleMain),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(':', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => setStateDialog(() =>
                    minSeleccionado = minSeleccionado == 59 ? 0 : minSeleccionado + 1),
                    icon: const Icon(Icons.keyboard_arrow_up_rounded, color: purpleMain),
                  ),
                  Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(color: purpleLight, shape: BoxShape.circle),
                    child: Center(
                      child: Text(minSeleccionado.toString().padLeft(2, '0'),
                          style: const TextStyle(color: purpleMain, fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setStateDialog(() =>
                    minSeleccionado = minSeleccionado == 0 ? 59 : minSeleccionado - 1),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: purpleMain),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: ['a.m.', 'p.m.'].map((p) {
                  final selected = periodoSeleccionado == p;
                  return GestureDetector(
                    onTap: () => setStateDialog(() => periodoSeleccionado = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? purpleMain : purpleLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(p,
                          style: TextStyle(
                            color: selected ? Colors.white : purpleMain,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          )),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade600)),
            ),
            GestureDetector(
              onTap: () {
                final minutos = minSeleccionado.toString().padLeft(2, '0');
                setState(() {
                  _nuevaHora = '$horaSeleccionada:$minutos $periodoSeleccionado';
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF8B6FF5), purpleMain]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Aceptar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarFechaCustom() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: DateTime(hoy.year + 1),
      locale: const Locale('es', 'MX'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: purpleMain,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _nuevaFecha = _formatFecha(picked);
        _nuevaHora = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Reagendar viaje',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                        Text(widget.viaje.codigo,
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                      ]),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.calendar_today_rounded, color: purpleMain, size: 18),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('FECHA Y HORA ACTUAL',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.8)),
                        const SizedBox(height: 2),
                        Text('${widget.viaje.fecha} · ${widget.viaje.hora}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A2E))),
                      ]),
                    ]),
                  ),

                  const SizedBox(height: 20),

                  const Text('NUEVA FECHA',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.8)),
                  const SizedBox(height: 10),

                  Row(children: [
                    Expanded(child: _opcionFechaCard(
                      selected: _opcionFecha == 'hoy',
                      onTap: () => setState(() {
                        _opcionFecha = 'hoy';
                        _nuevaFecha = _formatFecha(_hoy);
                        _nuevaHora = '';
                      }),
                      icon: '⚡', label: 'Hoy', sub: _formatDiaLabel(_hoy),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _opcionFechaCard(
                      selected: _opcionFecha == 'manana',
                      onTap: () => setState(() {
                        _opcionFecha = 'manana';
                        _nuevaFecha = _formatFecha(_manana);
                        _nuevaHora = '';
                      }),
                      icon: '📅', label: 'Mañana', sub: _formatDiaLabel(_manana),
                    )),
                  ]),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      await _seleccionarFechaCustom();
                      if (_nuevaFecha.isNotEmpty) setState(() => _opcionFecha = 'otra');
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: _opcionFecha == 'otra' ? purpleLight : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _opcionFecha == 'otra' ? purpleMain : const Color(0xFFF0F0F0),
                          width: _opcionFecha == 'otra' ? 2 : 1,
                        ),
                      ),
                      child: Column(children: [
                        const Icon(Icons.calendar_month_rounded, color: purpleMain, size: 22),
                        const SizedBox(height: 6),
                        Text(_opcionFecha == 'otra' ? _nuevaFecha : 'Otra fecha y hora',
                            style: const TextStyle(color: purpleMain, fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(_opcionFecha == 'otra' ? 'Toca para cambiar' : 'Elige desde el calendario',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (_opcionFecha.isNotEmpty) ...[
                    const Text('HORA DE SALIDA',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _seleccionarHora,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: _nuevaHora.isEmpty ? const Color(0xFFF7F8FC) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _nuevaHora.isEmpty ? const Color(0xFFEEEEEE) : purpleMain,
                            width: _nuevaHora.isEmpty ? 1 : 1.5,
                          ),
                        ),
                        child: Row(children: [
                          Icon(Icons.schedule_rounded, size: 18,
                              color: _nuevaHora.isEmpty ? Colors.grey.shade400 : purpleMain),
                          const SizedBox(width: 10),
                          Text(_nuevaHora.isEmpty ? '--:-- -----' : _nuevaHora,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                                  color: _nuevaHora.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A2E))),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (_puedeConfirmar) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDFDF5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFB7EBD4)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.check_box_rounded, color: Color(0xFF27AE60), size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_resumenFechaHora,
                              style: const TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 2),
                          const Text('Confirma para guardar el cambio',
                              style: TextStyle(color: Color(0xFF27AE60), fontSize: 11)),
                        ])),
                      ]),
                    ),
                    const SizedBox(height: 16),
                  ],

                  GestureDetector(
                    onTap: _puedeConfirmar ? () {
                      Navigator.pop(context);
                      widget.onConfirmar(_nuevaFecha, _nuevaHora);
                    } : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: _puedeConfirmar
                            ? const LinearGradient(colors: [Color(0xFF8B6FF5), purpleMain])
                            : null,
                        color: _puedeConfirmar ? null : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _puedeConfirmar
                            ? [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Center(
                        child: Text('Confirmar reagendado',
                            style: TextStyle(
                              color: _puedeConfirmar ? Colors.white : Colors.grey.shade400,
                              fontWeight: FontWeight.w700, fontSize: 15,
                            )),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(16)),
                      child: const Center(
                        child: Text('Cancelar',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcionFechaCard({
    required bool selected, required VoidCallback onTap,
    required String icon, required String label, required String sub,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: selected ? purpleLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? purpleMain : const Color(0xFFF0F0F0), width: selected ? 2 : 1),
        ),
        child: Column(children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14,
              color: selected ? purpleMain : const Color(0xFF1A1A2E))),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
        ]),
      ),
    );
  }
}

// ── MODAL DE DETALLE ─────────────────────────────────────
class _DetalleModal extends StatelessWidget {
  final Viaje viaje;
  final VoidCallback onCancelar;
  final VoidCallback onReagendar; // ← agregado

  const _DetalleModal({
    required this.viaje,
    required this.onCancelar,
    required this.onReagendar, // ← agregado
  });

  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);

  bool get _puedeCancel =>
      viaje.estado != 'cancelado' && viaje.estado != 'completado';

  @override
  Widget build(BuildContext context) {
    final pasos = [
      {'label': 'Reservación confirmada', 'sub': 'Tu solicitud fue enviada correctamente', 'done': true},
      {'label': 'Conductor asignado', 'sub': 'Un conductor aceptó tu viaje y va al aeropuerto', 'done': viaje.estado != 'en_espera'},
      {'label': 'Viaje en curso', 'sub': 'Traslado en proceso hacia tu destino', 'done': false},
      {'label': 'Viaje completado', 'sub': '¡Llegaste a tu destino con éxito!', 'done': false},
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(viaje.destino,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1A1A2E))),
                        Text(viaje.codigo, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                      ]),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (viaje.estado == 'en_camino' || viaje.estado == 'conductor_asignado')
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: purpleLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFDDD8FF)),
                      ),
                      child: Row(children: [
                        const Text('🚕', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Conductor asignado',
                            style: TextStyle(color: purpleMain, fontWeight: FontWeight.w700, fontSize: 13))),
                        Text('Tu conductor está en camino al aeropuerto',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                      ]),
                    ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: Column(children: [
                      _rutaRow(icon: Icons.circle, iconColor: purpleMain,
                          title: 'Aeropuerto Ángel Albino Corzo', sub: 'TGZ · Tuxtla Gutiérrez, Chiapas'),
                      Padding(padding: const EdgeInsets.only(left: 9),
                          child: Container(width: 2, height: 20, color: const Color(0xFFDDD8FF))),
                      _rutaRow(icon: Icons.circle, iconColor: const Color(0xFF1A1A2E),
                          title: viaje.destino, sub: 'Chiapas, México'),
                    ]),
                  ),

                  const SizedBox(height: 24),

                  const Text('ESTADO DEL VIAJE',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.8)),
                  const SizedBox(height: 14),

                  ...List.generate(pasos.length, (i) {
                    final paso = pasos[i];
                    final isDone = paso['done'] as bool;
                    final isActive = !isDone && (i == 0 || (pasos[i - 1]['done'] as bool));
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: isDone ? purpleMain : isActive ? purpleLight : const Color(0xFFF0F0F0),
                              shape: BoxShape.circle,
                              border: isActive ? Border.all(color: purpleMain, width: 2) : null,
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                                  : Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                  color: isActive ? purpleMain : Colors.black38)),
                            ),
                          ),
                          if (i < pasos.length - 1)
                            Container(width: 2, height: 36, color: isDone ? purpleMain : const Color(0xFFEEEEEE)),
                        ]),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(paso['label'] as String,
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
                                      color: isDone || isActive ? const Color(0xFF1A1A2E) : Colors.grey.shade400)),
                              const SizedBox(height: 3),
                              Text(paso['sub'] as String,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                              const SizedBox(height: 20),
                            ]),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 8),

                  const Text('DETALLES DEL SERVICIO',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  _detalleContainer([
                    _detalleRow('🚕', 'Unidad', viaje.unidad),
                    _divider(),
                    _detalleRow('📅', 'Fecha', viaje.fecha),
                    _divider(),
                    _detalleRow('🕐', 'Hora', viaje.hora),
                    _divider(),
                    _detalleRow('⚡', 'Tipo', viaje.tipo),
                  ]),

                  const SizedBox(height: 20),

                  const Text('PAGO',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  _detalleContainer([
                    _detalleRow('💵', 'Método', viaje.pago),
                    _divider(),
                    _detalleRow('🧾', 'Total', '${viaje.precio} MXN', isTotal: true),
                  ]),

                  const SizedBox(height: 24),

                  // Botón cerrar
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF8B6FF5), purpleMain]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: purpleMain.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: const Center(
                        child: Text('Cerrar detalle',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                    ),
                  ),

                  // ← Botón reagendar agregado
                  if (_puedeCancel) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () { Navigator.pop(context); onReagendar(); },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EDFF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFDDD8FF)),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                          Icon(Icons.calendar_month_rounded, color: purpleMain, size: 18),
                          SizedBox(width: 8),
                          Text('Reagendar viaje',
                              style: TextStyle(color: purpleMain, fontWeight: FontWeight.w700, fontSize: 14)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () { Navigator.pop(context); onCancelar(); },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.cancel_outlined, color: Colors.red.shade400, size: 18),
                          const SizedBox(width: 8),
                          Text('Cancelar reservación',
                              style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w700, fontSize: 14)),
                        ]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rutaRow({required IconData icon, required Color iconColor, required String title, required String sub}) {
    return Row(children: [
      Icon(icon, color: iconColor, size: 12),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1A2E))),
        Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ])),
    ]);
  }

  Widget _detalleContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(children: children),
    );
  }

  Widget _detalleRow(String emoji, String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400)),
          ]),
          Text(value, style: TextStyle(fontSize: 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: isTotal ? purpleMain : const Color(0xFF1A1A2E))),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF5F5F5), indent: 16, endIndent: 16);
}