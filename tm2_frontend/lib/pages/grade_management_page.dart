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

  Future<void> fetchCourseGrades(int courseId) async {
    try {
      final data = await apiService.getCourseGrades(courseId);
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

  Future<void> deleteGrade(int courseId, int studentId) async {
    try {
      await apiService.deleteGrade(courseId, studentId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note supprimée avec succès.")),
      );
      fetchCourseGrades(courseId); // Rafraîchir la liste des notes
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression de la note.")),
      );
      print("Error deleting grade: $e");
    }
  }

  void openEditGradeForm(
      int courseId, Map<String, dynamic> student, double currentGrade) {
    final _gradeController = TextEditingController(text: currentGrade.toString());
    ValueNotifier<String> errorMessageNotifier = ValueNotifier("");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Modifier la note",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        content: ValueListenableBuilder<String>(
          valueListenable: errorMessageNotifier,
          builder: (context, errorMessage, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Étudiant : ${student['name']} ${student['lastname']} (${student['matricule']})",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                TextField(
                  controller: _gradeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Note",
                    errorText: errorMessage.isNotEmpty ? errorMessage : null,
                  ),
                  onChanged: (_) {
                    errorMessageNotifier.value = ""; // Réinitialise l'erreur
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final newGradeText = _gradeController.text;
              if (newGradeText.isEmpty) {
                errorMessageNotifier.value = "Le champ ne doit pas être vide.";
                return;
              }

              final newGrade = double.tryParse(newGradeText);
              if (newGrade == null || newGrade < 0 || newGrade > 20) {
                errorMessageNotifier.value = "La note doit être comprise entre 0 et 20.";
                return;
              }

              try {
                await apiService.updateGrade(courseId, student['id'], newGrade);
                Navigator.of(context).pop();
                fetchCourseGrades(courseId); // Rafraîchir les données
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la modification de la note')),
                );
                print("Error updating grade: $e");
              }
            },
            child: Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des notes"),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
          ? courses.isEmpty
          ? Center(
        child: Text(
          "Aucune note n'est disponible.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      )
          : ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                course['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => fetchCourseGrades(course['id']),
            ),
          );
        },
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Cours : ${selectedCourse!['name']}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: selectedCourse!['grades'].isEmpty
                ? Center(
              child: Text(
                "Aucune note n'est disponible pour ce cours.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
                : ListView.builder(
              itemCount: selectedCourse!['grades'].keys.length,
              itemBuilder: (context, index) {
                final studentId = selectedCourse!['grades']
                    .keys
                    .elementAt(index);
                final grade =
                selectedCourse!['grades'][studentId.toString()];

                return FutureBuilder<Map<String, dynamic>>(
                  future: apiService
                      .getStudentById(int.parse(studentId)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        title: Text("Chargement..."),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text("Erreur : ${snapshot.error}"),
                      );
                    } else {
                      final student = snapshot.data!;
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                              "${student['name']} ${student['lastname']} (${student['matricule']})"),
                          subtitle: Text(
                              "Note: ${grade ?? 'Pas de note'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.blue),
                                onPressed: () => openEditGradeForm(
                                  selectedCourse!['id'],
                                  student,
                                  grade ?? 0.0,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => deleteGrade(
                                  selectedCourse!['id'],
                                  student['id'],
                                ),
                              ),
                            ],
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
