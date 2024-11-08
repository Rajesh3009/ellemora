class UserModel {
  final int id;
  final String email;
  final String username;
  final String token;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      token: json['token'] ?? '',
    );
  }
} 