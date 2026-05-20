import 'viaje_model.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  String nombre = '';
  String email = '';
  String telefono = '';

  List<Viaje> viajes = [];

  String get inicial => nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U';

  void login({required String nombre, required String email}) {
    this.nombre = nombre;
    this.email = email;
  }

  void logout() {
    nombre = '';
    email = '';
    telefono = '';
    viajes = [];
  }
}