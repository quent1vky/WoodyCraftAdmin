import 'dart:convert';
import 'package:http/http.dart' as http;

class Login {
  final int id;
  final String email;
  final String? email_verified_at;
  final String role;
  final String user_id;
  final String created_at;
  final String updated_at;

  Login({
    required this.id,
    required this.email,
    this.email_verified_at,
    required this.role,
    required this.user_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['id'],
      email: json['email'],
      email_verified_at: json['email_verified_at'],
      role: json['role'],
      user_id: json['user_id'].toString(),
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString(),
    );
  }

  static Future<Login> login(String email, String password) async {
    final String apiUrl = "http://127.0.0.1:8080/api/authentificate"; 
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return Login.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la connexion: ${response.body}');
    }
  }
}

