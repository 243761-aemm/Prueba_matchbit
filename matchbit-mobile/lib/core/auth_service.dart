import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

// 鈹€鈹€ Almac茅n temporal en memoria 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
final Map<String, _PendingCode> _pendingCodes = {};

class _PendingCode {
  final String code;
  final DateTime expiresAt;

  _PendingCode(this.code)
      : expiresAt = DateTime.now().add(const Duration(minutes: 10));

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class AuthService {
  static const String _baseUrl =
      'https://inventix-api-development.up.railway.app/api/v1';

  // 鈹€鈹€ LOGIN 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/authentication/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Correo o contrase帽a incorrectos',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexi贸n, intenta de nuevo',
      };
    }
  }

  // 鈹€鈹€ REGISTRO 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
  static Future<Map<String, dynamic>> registro({
    required String email,
    required String password,
    required String whatsapp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/commercial/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'whatsapp': whatsapp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al crear la cuenta',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexi贸n, intenta de nuevo',
      };
    }
  }

<<<<<<< HEAD
  // 鈹€鈹€ CREDENCIALES EMAILJS 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
  static const _emailjsServiceId = 'service_utqodpk';
  static const _emailjsTemplateId = 'template_kdm38hm';
  static const _emailjsPublicKey = 'qLSNFfXgTsq5Mhwlt';
=======
  // ── CREDENCIALES EMAILJS ───────────────────────────────
  static const _emailjsServiceId = 'service_oe45npp';
  static const _emailjsTemplateId = 'template_iywl8vy';
  static const _emailjsPublicKey = 'hKwCpWk34KLat-CCh';
>>>>>>> aa088c1d7629867c7d479b9a2e228499c9969bd1

  // 鈹€鈹€ PASO 1: Genera c贸digo y lo env铆a por EmailJS 鈹€鈹€鈹€鈹€鈹€鈹€鈹€
  static Future<Map<String, dynamic>> sendPasswordResetCode({
    required String email,
  }) async {
    try {
      final code = (1000 + Random().nextInt(9000)).toString();
      _pendingCodes[email] = _PendingCode(code);

      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _emailjsServiceId,
          'template_id': _emailjsTemplateId,
          'user_id': _emailjsPublicKey,
          'template_params': {
<<<<<<< HEAD
            'to_email': email,
            'otp_code': code,
=======
            'email': email,
            'link': 'Tu código es: $code (expira en 10 minutos)',
>>>>>>> aa088c1d7629867c7d479b9a2e228499c9969bd1
          },
        }),
      );

<<<<<<< HEAD
      // 馃敟 DEBUG (MUY IMPORTANTE)
=======
      // 🔥 DEBUG (MUY IMPORTANTE)
>>>>>>> aa088c1d7629867c7d479b9a2e228499c9969bd1
      print('========== EMAILJS DEBUG ==========');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');
      print('===================================');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'C贸digo enviado exitosamente'};
      } else {
        return {
          'success': false,
          'message': 'Error EmailJS: ${response.body}',
        };
      }
    } catch (e) {
      print('ERROR GENERAL: $e');
      return {
        'success': false,
        'message': 'Error de conexi贸n. Intenta nuevamente.',
      };
    }
  }

  // 鈹€鈹€ PASO 2: Verifica el c贸digo ingresado 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
  static Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    final pending = _pendingCodes[email];

    if (pending == null) {
      return {
        'success': false,
        'message': 'No hay una solicitud activa para este correo.',
      };
    }

    if (pending.isExpired) {
      _pendingCodes.remove(email);
      return {
        'success': false,
        'message': 'El c贸digo ha expirado. Solicita uno nuevo.',
      };
    }

    if (pending.code != code) {
      return {
        'success': false,
        'message': 'C贸digo incorrecto. Verifica e intenta de nuevo.',
      };
    }

    return {'success': true};
  }

  // 鈹€鈹€ PASO 3: Actualiza la contrase帽a 鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final verifyResult = await verifyResetCode(email: email, code: code);
    if (!verifyResult['success']) return verifyResult;

    _pendingCodes.remove(email);
    return {'success': true, 'message': 'Contrase帽a actualizada exitosamente'};
  }
}