import 'package:flutter/material.dart';
import '../../home/view/trip_details_page.dart';
import 'package:taxis/core/user_session.dart';
class VehicleSelectionPage extends StatefulWidget {
  final String destino;
  final String km;

  const VehicleSelectionPage({
    super.key,
    required this.destino,
    required this.km,
  });

  @override
  State<VehicleSelectionPage> createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage> {
  static const purpleMain = Color(0xFF6C4CF1);
  static const purpleLight = Color(0xFFF0EDFF);
  static const purpleMid = Color(0xFFE4DEFF);
  static const bgColor = Color(0xFFF7F8FC);

  int? selectedIndex;

  final unidades = [
    {
      'nombre': 'Taxi Ejecutivo',
      'descripcion': 'Sedán premium · Confort garantizado',
      'pasajeros': '4',
      'maletas': '2',
      'tiempo': '5 min',
      'precio': '\$220',
      'tag': 'Más popular',
      'icon': 'sedan',
    },
    {
      'nombre': 'SUV Premium',
      'descripcion': 'Camioneta amplia · Ideal para familias',
      'pasajeros': '6',
      'maletas': '4',
      'tiempo': '8 min',
      'precio': '\$517',
      'tag': '',
      'icon': 'suv',
    },
    {
      'nombre': 'Van Ejecutiva',
      'descripcion': 'Sprinter · Para grupos y equipaje extra',
      'pasajeros': '10',
      'maletas': '8',
      'tiempo': '12 min',
      'precio': '\$850',
      'tag': 'Grupos',
      'icon': 'van',
    },
  ];

  IconData _vehicleIcon(String type) {
    switch (type) {
      case 'sedan': return Icons.directions_car_rounded;
      case 'suv':   return Icons.airport_shuttle_rounded;
      case 'van':   return Icons.directions_bus_rounded;
      default:      return Icons.directions_car_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: _bottomBar(context),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _stepProgress(),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
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
                    TextSpan(text: 'APEX', style: TextStyle(color: purpleMain, fontWeight: FontWeight.w800, fontSize: 17, letterSpacing: 0.5)),
                    TextSpan(text: ' Transfer', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 17)),
                  ]),
                ),
              ]),
              CircleAvatar(
                backgroundColor: purpleMid,
                radius: 20,
                child: Text(
                  UserSession().inicial,
                  style: TextStyle(color: purpleMain, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Elige tu unidad', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 5),
          RichText(
            text: const TextSpan(children: [
              TextSpan(text: '¿Cómo quieres ', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              TextSpan(text: 'viajar?', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: purpleMain)),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: purpleLight,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: purpleMid),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flight_land_rounded, color: purpleMain, size: 14),
                const SizedBox(width: 6),
                const Text('TGZ', style: TextStyle(color: purpleMain, fontWeight: FontWeight.w600, fontSize: 12)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(Icons.arrow_forward_rounded, color: purpleMain.withOpacity(0.5), size: 13),
                ),
                const Icon(Icons.location_on_rounded, color: purpleMain, size: 14),
                const SizedBox(width: 6),
                Text(widget.destino,
                    style: const TextStyle(color: purpleMain, fontWeight: FontWeight.w600, fontSize: 12),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(width: 8),
                Text('· ${widget.km}', style: TextStyle(color: purpleMain.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepProgress() {
    const steps = ['Destino', 'Unidad', 'Detalles', 'Listo'];
    const currentStep = 2;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final filled = (i ~/ 2) + 1 < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: filled ? purpleMain : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }
          final step = i ~/ 2 + 1;
          final active = step == currentStep;
          final done = step < currentStep;
          return Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: active || done ? purpleMain : const Color(0xFFEEEEEE),
                shape: BoxShape.circle,
                boxShadow: active ? [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))] : [],
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                    : Text('$step', style: TextStyle(
                    color: active ? Colors.white : Colors.black38,
                    fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 5),
            Text(steps[step - 1], style: TextStyle(
              fontSize: 11,
              color: active ? purpleMain : Colors.grey.shade400,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            )),
          ]);
        }),
      ),
    );
  }

  Widget _body() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        Text('Unidades disponibles',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        ...List.generate(unidades.length, (i) => _vehicleCard(i)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: purpleLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: purpleMid),
          ),
          child: Row(children: [
            const Icon(Icons.verified_user_rounded, color: purpleMain, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Todos los traslados incluyen seguro de viaje y conductores certificados.',
                style: TextStyle(color: purpleMain.withOpacity(0.8), fontSize: 12, height: 1.5),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _vehicleCard(int index) {
    final u = unidades[index];
    final isSelected = selectedIndex == index;
    final isPopular = u['tag'] == 'Más popular';

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? purpleMain : const Color(0xFFF0F0F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: purpleMain.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))]
              : [const BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: isSelected ? purpleMain : purpleLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_vehicleIcon(u['icon'] ?? ''),
                    color: isSelected ? Colors.white : purpleMain, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(u['nombre'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1A2E))),
                      if ((u['tag'] ?? '').isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isPopular ? const Color(0xFFFF6B35).withOpacity(0.1) : purpleLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(u['tag'] ?? '',
                              style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700,
                                color: isPopular ? const Color(0xFFFF6B35) : purpleMain,
                              )),
                        ),
                      ]
                    ]),
                    const SizedBox(height: 3),
                    Text(u['descripcion'] ?? '',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(u['precio'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: purpleMain)),
                  Text('MXN', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                ],
              ),
            ]),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoChip(Icons.people_rounded, '${u['pasajeros']} pasajeros'),
                _dividerV(),
                _infoChip(Icons.luggage_rounded, '${u['maletas']} maletas'),
                _dividerV(),
                _infoChip(Icons.schedule_rounded, 'Llega en ${u['tiempo']}'),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(children: [
      Icon(icon, size: 14, color: Colors.grey.shade400),
      const SizedBox(width: 5),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _dividerV() {
    return Container(width: 1, height: 16, color: const Color(0xFFEEEEEE));
  }

  Widget _bottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: purpleLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: purpleMid),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: purpleMain),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: selectedIndex == null ? null : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TripDetailsPage(
                    destino: widget.destino,
                    km: widget.km,
                    unidad: unidades[selectedIndex!]['nombre'] ?? '',
                    precio: unidades[selectedIndex!]['precio'] ?? '',
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 50,
              decoration: BoxDecoration(
                gradient: selectedIndex != null
                    ? const LinearGradient(colors: [Color(0xFF8B6FF5), purpleMain])
                    : null,
                color: selectedIndex != null ? null : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
                boxShadow: selectedIndex != null
                    ? [BoxShadow(color: purpleMain.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))]
                    : [],
              ),
              child: Center(
                child: Text(
                  selectedIndex != null
                      ? 'Continuar con ${unidades[selectedIndex!]['nombre']}'
                      : 'Selecciona una unidad',
                  style: TextStyle(
                    color: selectedIndex != null ? Colors.white : Colors.grey.shade500,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}