import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/role_model.dart';

class RoleController {
  final String baseUrl =
      'http://localhost:3000/api_v1/role';

  // Get all roles
  Future<List<Role>> getAllRoles(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<Role> roles = jsonList.map((json) => Role.fromJson(json)).toList();
        return roles;
      } else {
        print('Error fetching roles: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching roles: $e');
      return [];
    }
  }

  // Get role by ID
  Future<Role?> getRoleById(int roleId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$roleId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return Role.fromJson(jsonData);
      } else {
        print('Error fetching role: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching role: $e');
      return null;
    }
  }

  // Create role
  Future<dynamic> createRole(
      Map<String, dynamic> roleData, String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(roleData),
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        return responseData['data'][0];
      } else {
        print('Error creating role: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating role: $e');
      return null;
    }
  }

  // Update role
  Future<dynamic> updateRole(
      Map<String, dynamic> roleData, String token, int roleId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$roleId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(roleData),
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        return responseData['data'][0];
      } else {
        print('Error updating role: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating role: $e');
      return null;
    }
  }

  // Delete role
  Future<dynamic> deleteRole(int roleId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$roleId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        return responseData;
      } else {
        print('Error deleting role: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error deleting role: $e');
      return null;
    }
  }
}
