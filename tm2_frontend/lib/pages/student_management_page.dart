import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StudentManagementPage extends StatefulWidget {
  @override
  _StudentManagementPageState createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  final ApiService apiService = ApiService();
  List<dynamic> students = [];
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final data = await apiService.getStudents();
      setState(() {
        students = data;
      });
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  void openStudentForm({int? id, String? name, String? lastname, String? matricule}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: name);
    final _lastnameController = TextEditingController(text: lastname);
    final _matriculeController = TextEditingController(text: matricule);
    String popupErrorMessage = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[100],
        title: Text(
          id == null ? "Ajouter un étudiant" : "Modifier l'étudiant",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Prénom"),
                validator: (value) => value!.isEmpty ? "Obligatoire" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) => value!.isEmpty ? "Obligatoire" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _matriculeController,
                decoration: InputDecoration(labelText: "Matricule"),
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
              final student = {
                "name": _nameController.text,
                "lastname": _lastnameController.text,
                "matricule": _matriculeController.text
              };

              try {
                if (id == null) {
                  await apiService.addStudent(student);
                } else {
                  await apiService.updateStudent(id, student);
                }
                Navigator.of(context).pop(); // Fermer le popup
                fetchStudents(); // Rafraîchir la liste
              } catch (e) {
                setState(() {
                  popupErrorMessage = "Erreur lors de l'enregistrement.";
                });
                print("Error saving student: $e");
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
        content: Text("Voulez-vous vraiment supprimer cet étudiant ?"),
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
        await apiService.deleteStudent(id);
        fetchStudents();
      } catch (e) {
        print("Error deleting student: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer les étudiants"),
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
              onPressed: () => openStudentForm(),
              child: Text("Ajouter un étudiant"),
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? Center(
              child: Text(
                "Aucun étudiant n'est disponible.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
                : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("${student['name']} ${student['lastname']}"),
                    subtitle: Text("Matricule: ${student['matricule']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => openStudentForm(
                            id: student['id'],
                            name: student['name'],
                            lastname: student['lastname'],
                            matricule: student['matricule'],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => handleDelete(student['id']),
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
