class UserStatus {
  final int userStatusId;
  final String userStatusName;
  final String? userStatusDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserStatus({
    required this.userStatusId,
    required this.userStatusName,
    this.userStatusDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      userStatusId: json['User_status_id'] as int? ?? 0,
      userStatusName: json['User_status_name'] as String? ?? '',
      userStatusDescription: json['User_status_description'] as String?,
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
    return 'UserStatus{id: $userStatusId, name: $userStatusName, description: $userStatusDescription}';
  }
}
