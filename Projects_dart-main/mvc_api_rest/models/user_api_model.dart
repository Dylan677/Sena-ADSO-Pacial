import 'dart:convert';

class UserApiModel {
  final int id;
  final String user;
  final String password;
  final String role;
  final String status;
  final String createdAt;
  final String updatedAt;
  UserApiModel({
    required this.id,
    required this.user,
    required this.password,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
        id: json['Api_user_id'],
        user: json['Api_user'],
        password: json['Api_password'],
        role: json['Api_role'],
        status: json['Api_status'],
        createdAt: json['Created_at'],
        updatedAt: json['Updated_at']);
  }
  String toJsonString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'Api_user_id': id,
      'Api_user': user,
      'Api_password': password,
      'Api_role': role,
      'Api_status': status,
      'Created_at': createdAt,
      'Updated_at': updatedAt
    };
  }
}
