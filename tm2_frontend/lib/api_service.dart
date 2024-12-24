import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "http://10.0.2.2:8081";

  static Future<List<Map<String, dynamic>>> fetchStudents() async {
    final response = await http.get(Uri.parse("$apiUrl/students"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load students");
    }
  }

  static Future<void> addStudent(String name, String lastname, String matricule) async {
    final response = await http.post(
      Uri.parse("$apiUrl/students"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "lastname": lastname,
        "matricule": matricule,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add student");
    }
  }

  static Future<void> updateStudent(int id, String name, String lastname, String matricule) async {
    final response = await http.put(
      Uri.parse("$apiUrl/students/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "lastname": lastname,
        "matricule": matricule,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update student");
    }
  }

  static Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/students/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete student");
    }
  }
}