import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static String get _serviceId => dotenv.get('EMAILJS_SERVICE_ID', fallback: '');
  static String get _templateId => dotenv.get('EMAILJS_TEMPLATE_ID', fallback: '');
  static String get _publicKey => dotenv.get('EMAILJS_PUBLIC_KEY', fallback: '');

  static Future<bool> sendOTP({
    required String toEmail,
    required String otpCode,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'email': toEmail,
            'passcode': otpCode,
            'time': '15 minutes',
          }
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
