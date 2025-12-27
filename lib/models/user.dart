import 'dart:convert';

class User {
  final int id;
  final String username;
  final String fullName;
  final int age;
  final String gender;
  final String email;
  final String password; // Should be hashed in a real app, but included for structure
  final String role; // 'customer' or 'admin'

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.email,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );
  }
}