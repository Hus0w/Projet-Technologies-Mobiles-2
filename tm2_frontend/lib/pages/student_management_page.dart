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
        title: Text(id == null ? "Ajouter un étudiant" : "Modifier l'étudiant"),
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
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) => value!.isEmpty ? "Obligatoire" : null,
              ),
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
        title: Text("Confirmer la suppression"),
        content: Text("Voulez-vous vraiment supprimer cet étudiant ?"),
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
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => openStudentForm(),
            child: Text("Ajouter un étudiant"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text("${student['name']} ${student['lastname']}"),
                  subtitle: Text("Matricule: ${student['matricule']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => openStudentForm(
                          id: student['id'],
                          name: student['name'],
                          lastname: student['lastname'],
                          matricule: student['matricule'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => handleDelete(student['id']),
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
