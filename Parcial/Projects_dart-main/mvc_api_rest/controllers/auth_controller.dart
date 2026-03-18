import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/console_session.dart';

class AuthController {
  late final String url_app =
      "http://localhost:3000/api_v1/"; // Reemplaza con tu URL real
  late final String baseUrl =
      '$url_app/apiUserLogin'; // Reemplaza con tu URL real

  // Método para login de usuario
  Future<String> login(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        // Decodificar el JSON
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Extraer el token del JSON
        String token = jsonData['token'] ?? '';
        ConsoleSession.saveSession(userData['api_user'], token);
        return token;
      } else {
        print('Error fetching user: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error fetching user: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>?> validateToken(
      Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$url_app/apiUserVerifyToken'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        // Decodificar el JSON
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Extraer el token del JSON
        dynamic user = jsonData['user'];

        Map<String, dynamic> userData = {
          'id': user['id'],
          'role': user['api_role'],
          'status': user['status'],
          'iat': user['iat'],
          'exp': user['exp'],
        };

        return userData;
      } else {
        print('Error fetching user: ${response.statusCode}');
        ConsoleSession.closeSession();
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      ConsoleSession.closeSession();
      return null;
    }
  }

  // Method to register a new API user
  Future<Map<String, dynamic>?> register(
      Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${url_app}apiUser'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        Map<String, dynamic> errorData = json.decode(response.body);
        print('Error registering user: ${errorData['error'] ?? response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error registering user: $e');
      return null;
    }
  }
}
