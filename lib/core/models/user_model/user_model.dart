class UserModel {
  final String id;
  final String email;
  final String username;

  final String? profileImageUrl;
  final String createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.username,

    this.profileImageUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,

      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,

      'profile_image_url': profileImageUrl,
      'created_at': createdAt,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,

      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
