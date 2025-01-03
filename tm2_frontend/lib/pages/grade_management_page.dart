import 'package:flutter/material.dart';
import 'add_student_page.dart';
import '../services/api_service.dart';

class GradeManagementPage extends StatefulWidget {
  @override
  _GradeManagementPageState createState() => _GradeManagementPageState();
}

class _GradeManagementPageState extends State<GradeManagementPage> {
  final ApiService apiService = ApiService();
  List<dynamic> courses = [];
  Map<String, dynamic>? selectedCourse;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final data = await apiService.getCourses();
      setState(() {
        courses = data;
      });
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  void openEditGradeForm(
      int courseId, Map<String, dynamic> student, double currentGrade) {
    final _gradeController = TextEditingController(text: currentGrade.toString());
    String errorMessage = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier la note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Étudiant : ${student['name']} ${student['lastname']} (${student['matricule']})",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Note"),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newGradeText = _gradeController.text;
              if (newGradeText.isEmpty) {
                setState(() {
                  errorMessage = "Le champ ne doit pas être vide.";
                });
                return;
              }

              final newGrade = double.tryParse(newGradeText);
              if (newGrade == null) {
                setState(() {
                  errorMessage = "Entrez une note valide.";
                });
                return;
              }

              try {
                await apiService.updateGrade(courseId, student['id'], newGrade);
                Navigator.of(context).pop();
                fetchCourseGrades(courseId); // Rafraîchir les données
              } catch (e) {
                print("Error updating grade: $e");
              }
            },
            child: Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  Future<void> fetchCourseGrades(int courseId) async {
    try {
      final data = await apiService.getCourseGrades(courseId);
      print("Données reçues pour le cours $courseId : $data");

      setState(() {
        selectedCourse = {
          'id': data['id'],
          'name': data['name'],
          'grades': data['grades'] ?? {}
        };
      });
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des notes"),
        leading: selectedCourse == null
            ? null
            : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedCourse = null; // Retour à la liste des cours
            });
          },
        ),
      ),
      body: selectedCourse == null
          ? ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            title: Text(course['name']),
            onTap: () => fetchCourseGrades(course['id']),
          );
        },
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Cours : ${selectedCourse!['name']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedCourse!['grades'].keys.length,
              itemBuilder: (context, index) {
                final studentId = selectedCourse!['grades'].keys.elementAt(index);
                final grade = selectedCourse!['grades'][studentId.toString()];

                return FutureBuilder<Map<String, dynamic>>(
                  future: apiService.getStudentById(int.parse(studentId)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text("Chargement..."),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text("Erreur : ${snapshot.error}"),
                      );
                    } else {
                      final student = snapshot.data!;
                      return ListTile(
                        title: Text(
                            "${student['name']} ${student['lastname']} (${student['matricule']})"),
                        subtitle: Text("Note: ${grade ?? 'Pas de note'}"),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => openEditGradeForm(
                            selectedCourse!['id'],
                            student,
                            grade ?? 0.0,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: selectedCourse != null
          ? FloatingActionButton(
        onPressed: () async {
          final success = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentPage(
                courseId: selectedCourse!['id'],
                existingStudentIds: selectedCourse!['grades']
                    .keys
                    .map((key) => int.tryParse(key.toString()) ?? -1)
                    .where((id) => id != -1)
                    .cast<int>()
                    .toList(),
              ),
            ),
          );
          if (success == true) {
            fetchCourseGrades(selectedCourse!['id']);
          }
        },
        child: Icon(Icons.person_add),
      )
          : null,
    );
  }
}