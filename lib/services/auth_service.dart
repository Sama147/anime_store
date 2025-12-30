import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user.dart';

class AuthService {
  final String _baseUrl = kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
  static User? currentUser;

  Future<String> signup(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        currentUser = User.fromJson(jsonDecode(response.body));
        return "success";
      } else if (response.statusCode == 409) {
        return "account already exists";
      } else {
        // This will show the actual error from the server in your console
        print("Server Signup Error: ${response.body}");
        return "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Connection Error: $e");
      return "Could not connect to server";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        currentUser = User.fromJson(jsonDecode(response.body));
        return "success";
      } else {
        return "account incorrect or doesn't exist";
      }
    } catch (e) {
      return "Login failed: $e";
    }
  }
}