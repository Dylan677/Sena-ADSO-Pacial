class User {
  final int userId;
  final String userUser; // Hacer nullable
  final String userEmail; // Hacer nullable
  final String userPassword; // Hacer nullable
  final int rolesFk; // Hacer nullable
  final int userStatusFk; // Hacer nullable
  final DateTime? createdAt; // Hacer nullable
  final DateTime? updatedAt; // Hacer nullable

  User({
    required this.userId,
    required this.userUser,
    required this.userEmail,
    required this.userPassword,
    required this.rolesFk,
    required this.userStatusFk,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['User_id'] as int? ?? 0, // Valor por defecto si es null
      userUser: json['User_user'] as String,
      userEmail: json['User_email'] as String,
      userPassword: json['User_password'] as String,
      rolesFk: json['Roles_fk'] as int,
      userStatusFk: json['User_status_fk'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'User{id: $userId, email: $userEmail}';
  }
}
