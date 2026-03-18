class Role {
  final int roleId;
  final String roleName;
  final String? roleDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Role({
    required this.roleId,
    required this.roleName,
    this.roleDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['Roles_id'] as int? ?? 0,
      roleName: json['Roles_name'] as String? ?? '',
      roleDescription: json['Roles_description'] as String?,
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
    return 'Role{id: $roleId, name: $roleName, description: $roleDescription}';
  }
}
