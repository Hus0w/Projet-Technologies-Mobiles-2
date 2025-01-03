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
      throw Exception("Échec du chargement des étudiants");
    }
  }

  Future<void> addStudent(Map<String, dynamic> student) async {
    final response = await http.post(
      Uri.parse("$apiUrl/students"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student),
    );
    if (response.statusCode != 200) {
      throw Exception("Échec de l'ajout de l'étudiant");
    }
  }

  Future<void> updateStudent(int id, Map<String, dynamic> student) async {
    final response = await http.put(
      Uri.parse("$apiUrl/students/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student),
    );
    if (response.statusCode != 200) {
      throw Exception("Échec de la mise à jour de l'étudiant");
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/students/$id"));
    if (response.statusCode != 200) {
      throw Exception("Échec de la suppression de l'étudiant");
    }
  }

  // Cours
  Future<List<dynamic>> getCourses() async {
    final response = await http.get(Uri.parse("$apiUrl/courses"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Échec du chargement des cours");
    }
  }

  Future<void> addCourse(Map<String, dynamic> course) async {
    final response = await http.post(
      Uri.parse("$apiUrl/courses"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(course),
    );
    if (response.statusCode != 200) {
      throw Exception("Échec de l'ajout du cours");
    }
  }

  Future<void> updateCourse(int id, String newName) async {
    final response = await http.put(
      Uri.parse("$apiUrl/courses/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": newName}),
    );
    if (response.statusCode != 200) {
      throw Exception("Échec de la mise à jour du cours");
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/courses/$id"));
    if (response.statusCode != 200) {
      throw Exception("Échec de la suppression du cours");
    }
  }

  // Notes
  Future<Map<String, dynamic>> getCourseGrades(int courseId) async {
    final response = await http.get(Uri.parse('$apiUrl/courses/$courseId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des notes du cours');
    }
  }

  Future<void> updateGrade(int courseId, int studentId, double note) async {
    final response = await http.post(
      Uri.parse("$apiUrl/courses/$courseId/grades"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentId": studentId, "note": note}),
    );
    if (response.statusCode != 200) {
      throw Exception("Échec de la mise à jour de la note");
    }
  }

  Future<void> deleteGrade(int courseId, int studentId) async {
    final response = await http.delete(
      Uri.parse("$apiUrl/courses/$courseId/grades"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentId": studentId}),
    );
    if (response.statusCode != 200) {
      throw Exception("Échec de la suppression de la note");
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

  Future<Map<String, dynamic>> getCourseStatistics(int courseId) async {
    final response =
    await http.get(Uri.parse("$apiUrl/courses/$courseId/statistics"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Échec du chargement des statistiques du cours");
    }
  }

  Future<double> getStudentAverage(int studentId) async {
    final response = await http.get(Uri.parse("$apiUrl/students/$studentId/average"));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception("Échec du chargement de la moyenne de l'étudiant");
    }
  }
}
