import 'dart:convert';

class User {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final String createdAt;
  final String updatedAt;
  final String hashedRt;


  User({
    required this.id, 
    required this.username, 
    required this.email,
    required this.passwordHash, 
    required this.createdAt, 
    required this.updatedAt, 
    required this.hashedRt, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'hashedRt': hashedRt
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? -1,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      passwordHash: map['passwordHash'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      hashedRt: map['hashedRt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
