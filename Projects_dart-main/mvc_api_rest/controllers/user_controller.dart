import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserController {
  final String baseUrl =
      'http://localhost:3000/api_v1/user'; // Reemplaza con tu URL real

  // Método para obtener un usuario específico por ID
  Future<List<User?>> getUserById(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        // Decodificar el JSON
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Convertir a objeto User
        User user = User.fromJson(jsonData);

        return [user];
      } else {
        print('Error fetching user: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching user: $e');
      return [];
    }
  }

  // Método para obtener todos los usuarios (asumiendo que la API devuelve una lista)
  Future<List<User>> getAllUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      //print(response);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        // Decodificar el JSON (asumiendo que es una lista)
        List<User> users = jsonList.map((json) => User.fromJson(json)).toList();

        return users;
      } else {
        print('Error al obtener usuarios: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Excepción en getAllUsers: $e');
      return [];
    }
  }

  // Método para crear un usuario
  Future<dynamic> createUser(
      Map<String, dynamic> userData, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(userData),
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        print(responseData['data'][0]['user']);
        Map<String, dynamic> getData = responseData['data'][0];
        Map<String, dynamic> newUser = {
          'User_id': getData['id'] as int,
          'User_user': getData['user'] as String,
          'User_password': getData['hashedPassword'] as String,
          'Roles_fk': getData['status'] as int,
          'User_status_fk': getData['role'] as int
        };
        return newUser;
      } else {
        print('Error al crear usuario: ${response.statusCode}');
        return Future.error('Error al crear usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en createUser: $e');
      return Future.error('Excepción en createUser: $e');
    }
  }

  // Método para editar un usuario
  Future<dynamic> updateUser(
      Map<String, dynamic> userData, String token, int userId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(userData),
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        print(responseData['data'][0]['user']);
        Map<String, dynamic> getData = responseData['data'][0];

        Map<String, dynamic> newUser = {
          'User_user': getData['user'] as String,
          'Roles_fk': getData['status'] as int,
          'User_status_fk': getData['role'] as int,
          'updated_at': getData['updated_at'] as String
        };
        return newUser;
      } else {
        print('Error al actualizar usuario: ${response.statusCode}');
        return Future.error(
            'Error al actualizar usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en updateUser: $e');
      return Future.error('Excepción en updateUser: $e');
    }
  }

  // Método para eliminar un usuario
  Future<dynamic> deleteUser(int userId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        Map<String, dynamic> newUser = {
          'data': [],
          'status': responseData['status'] as int,
          'deleted': responseData['deleted'] as int
        };
        return newUser;
      } else {
        print('Error fetching user: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching user: $e');
      return [];
    }
  }
}
