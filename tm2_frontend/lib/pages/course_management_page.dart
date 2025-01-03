import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CourseManagementPage extends StatefulWidget {
  @override
  _CourseManagementPageState createState() => _CourseManagementPageState();
}

class _CourseManagementPageState extends State<CourseManagementPage> {
  final ApiService apiService = ApiService();
  List<dynamic> courses = [];
  String errorMessage = "";

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

  void openCourseForm({int? id, String? name}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: name);
    String popupErrorMessage = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? "Ajouter un cours" : "Modifier le cours"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nom du cours"),
                validator: (value) => value!.isEmpty ? "Obligatoire" : null,
              ),
              if (popupErrorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    popupErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              final course = {
                "name": _nameController.text,
              };

              try {
                if (id == null) {
                  await apiService.addCourse(course);
                } else {
                  await apiService.updateCourse(id, course);
                }
                Navigator.of(context).pop(); // Fermer le popup
                fetchCourses(); // Rafraîchir la liste
              } catch (e) {
                setState(() {
                  popupErrorMessage = "Erreur lors de l'enregistrement.";
                });
                print("Error saving course: $e");
              }
            },
            child: Text(id == null ? "Ajouter" : "Modifier"),
          ),
        ],
      ),
    );
  }

  Future<void> handleDelete(int id) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la suppression"),
        content: Text("Voulez-vous vraiment supprimer ce cours ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await apiService.deleteCourse(id);
        fetchCourses();
      } catch (e) {
        print("Error deleting course: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer les cours"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => openCourseForm(),
            child: Text("Ajouter un cours"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => openCourseForm(
                          id: course['id'],
                          name: course['name'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => handleDelete(course['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
