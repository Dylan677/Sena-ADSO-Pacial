import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_status_model.dart';

class UserStatusController {
  final String baseUrl =
      'http://localhost:3000/api_v1/userStatus';

  // Get all user statuses
  Future<List<UserStatus>> getAllUserStatuses(String token) async {
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
        List<UserStatus> statuses =
            jsonList.map((json) => UserStatus.fromJson(json)).toList();
        return statuses;
      } else {
        print('Error fetching user statuses: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching user statuses: $e');
      return [];
    }
  }

  // Get user status by ID
  Future<UserStatus?> getUserStatusById(int statusId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$statusId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return UserStatus.fromJson(jsonData);
      } else {
        print('Error fetching user status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user status: $e');
      return null;
    }
  }

  // Create user status
  Future<dynamic> createUserStatus(
      Map<String, dynamic> statusData, String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(statusData),
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        return responseData['data'][0];
      } else {
        print('Error creating user status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating user status: $e');
      return null;
    }
  }

  // Update user status
  Future<dynamic> updateUserStatus(
      Map<String, dynamic> statusData, String token, int statusId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$statusId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(statusData),
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        return responseData['data'][0];
      } else {
        print('Error updating user status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating user status: $e');
      return null;
    }
  }

  // Delete user status
  Future<dynamic> deleteUserStatus(int statusId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$statusId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 201 || responseData['status'] == 200) {
        return responseData;
      } else {
        print('Error deleting user status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error deleting user status: $e');
      return null;
    }
  }
}
