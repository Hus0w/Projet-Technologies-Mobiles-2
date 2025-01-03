import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "http://10.0.2.2:8081";

  // Étudiants
  Future<List<dynamic>> getStudents() async {
    final response = await http.get(Uri.parse("$apiUrl/students"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load students");
    }
  }

  Future<void> addStudent(Map<String, dynamic> student) async {
    final response = await http.post(
      Uri.parse("$apiUrl/students"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add student");
    }
  }

  Future<void> updateStudent(int id, Map<String, dynamic> student) async {
    final response = await http.put(
      Uri.parse("$apiUrl/students/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update student");
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/students/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete student");
    }
  }

  // Cours
  Future<List<dynamic>> getCourses() async {
    final response = await http.get(Uri.parse("$apiUrl/courses"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load courses");
    }
  }

  Future<void> addCourse(Map<String, dynamic> course) async {
    final response = await http.post(
      Uri.parse("$apiUrl/courses"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(course),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add course");
    }
  }

  Future<void> updateCourse(int id, Map<String, dynamic> course) async {
    final response = await http.put(
      Uri.parse("$apiUrl/courses/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(course),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update course");
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/courses/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete course");
    }
  }

  // Notes
  Future<Map<String, dynamic>> getCourseGrades(int courseId) async {
    final response = await http.get(Uri.parse('$apiUrl/courses/$courseId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load course grades');
    }
  }

  Future<void> updateGrade(int courseId, int studentId, double note) async {
    final response = await http.post(
      Uri.parse("$apiUrl/courses/$courseId/grades"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentId": studentId, "note": note}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update grade");
    }
  }

  Future<void> deleteGrade(int courseId, int studentId) async {
    final response = await http.delete(
      Uri.parse("$apiUrl/courses/$courseId/grades"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentId": studentId}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete grade");
    }
  }

  Future<Map<String, dynamic>> getStudentById(int studentId) async {
    final response = await http.get(Uri.parse('$apiUrl/students/$studentId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération de l\'étudiant');
    }
  }

  Future<void> addGrade(int courseId, int studentId, double grade) async {
    final response = await http.post(
      Uri.parse('$apiUrl/courses/$courseId/grades'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'studentId': studentId, 'note': grade}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erreur lors de l\'ajout de la note');
    }
  }
}
