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
        backgroundColor: Colors.grey[100],
        title: Text(
          id == null ? "Ajouter un cours" : "Modifier le cours",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              final newName = _nameController.text;

              try {
                if (id == null) {
                  await apiService.addCourse({"name": newName});
                } else {
                  await apiService.updateCourse(id, newName);
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
        backgroundColor: Colors.grey[100],
        title: Text(
          "Confirmer la suppression",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        content: Text("Voulez-vous vraiment supprimer ce cours ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Supprimer",
              style: TextStyle(color: Colors.red),
            ),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => openCourseForm(),
              child: Text("Ajouter un cours"),
            ),
          ),
          Expanded(
            child: courses.isEmpty
                ? Center(
              child: Text(
                "Aucun cours n'est disponible.",
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => openCourseForm(
                            id: course['id'],
                            name: course['name'],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => handleDelete(course['id']),
                        ),
                      ],
                    ),
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
