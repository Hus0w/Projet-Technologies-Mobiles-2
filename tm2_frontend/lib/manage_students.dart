import 'package:flutter/material.dart';
import 'api_service.dart';

class ManageStudentsPage extends StatefulWidget {
  @override
  _ManageStudentsPageState createState() => _ManageStudentsPageState();
}

class _ManageStudentsPageState extends State<ManageStudentsPage> {
  List<Map<String, dynamic>> students = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final data = await ApiService.fetchStudents();
      setState(() {
        students = data;
      });
    } catch (e) {
      print("Failed to fetch students: $e");
    }
  }

  Future<void> addStudent() async {
    if (nameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        matriculeController.text.isEmpty) {
      setState(() {
        errorMessage = "Veuillez remplir tous les champs.";
      });
      return;
    }

    try {
      await ApiService.addStudent(
        nameController.text,
        lastnameController.text,
        matriculeController.text,
      );
      nameController.clear();
      lastnameController.clear();
      matriculeController.clear();
      setState(() {
        errorMessage = ""; // Réinitialiser le message d'erreur
      });
      fetchStudents();
      Navigator.of(context).pop(); // Fermer le popup après ajout
    } catch (e) {
      print("Failed to add student: $e");
    }
  }

  void showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Ajouter un étudiant'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nom'),
                    onChanged: (_) {
                      setState(() {
                        errorMessage = ""; // Réinitialiser le message d'erreur
                      });
                    },
                  ),
                  TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(labelText: 'Nom de famille'),
                    onChanged: (_) {
                      setState(() {
                        errorMessage = ""; // Réinitialiser le message d'erreur
                      });
                    },
                  ),
                  TextField(
                    controller: matriculeController,
                    decoration: InputDecoration(labelText: 'Matricule'),
                    onChanged: (_) {
                      setState(() {
                        errorMessage = ""; // Réinitialiser le message d'erreur
                      });
                    },
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer le popup
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        lastnameController.text.isEmpty ||
                        matriculeController.text.isEmpty) {
                      setState(() {
                        errorMessage = "Veuillez remplir tous les champs.";
                      });
                    } else {
                      addStudent();
                    }
                  },
                  child: Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditDialog(int index) {
    String errorMessageEdit = ""; // Message d'erreur pour le popup de modification
    nameController.text = students[index]['name'];
    lastnameController.text = students[index]['lastname'];
    matriculeController.text = students[index]['matricule'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Modifier étudiant'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nom'),
                    onChanged: (_) {
                      setState(() {
                        errorMessageEdit = ""; // Réinitialiser le message d'erreur
                      });
                    },
                  ),
                  TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(labelText: 'Nom de famille'),
                    onChanged: (_) {
                      setState(() {
                        errorMessageEdit = ""; // Réinitialiser le message d'erreur
                      });
                    },
                  ),
                  TextField(
                    controller: matriculeController,
                    decoration: InputDecoration(labelText: 'Matricule'),
                    onChanged: (_) {
                      setState(() {
                        errorMessageEdit = ""; // Réinitialiser le message d'erreur
                      });
                    },
                  ),
                  if (errorMessageEdit.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        errorMessageEdit,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer le popup sans action
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    // Vérification des champs avant d'appeler updateStudent
                    if (nameController.text.isEmpty ||
                        lastnameController.text.isEmpty ||
                        matriculeController.text.isEmpty) {
                      setState(() {
                        errorMessageEdit = "Veuillez remplir tous les champs.";
                      });
                    } else {
                      updateStudent(students[index]['id']); // Mettre à jour l'étudiant
                      Navigator.of(context).pop(); // Fermer le popup après modification
                    }
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> confirmDeleteStudent(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir supprimer cet étudiant ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le popup
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer le popup
                await deleteStudent(id); // Supprimer l'étudiant
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateStudent(int id) async {
    try {
      await ApiService.updateStudent(
        id,
        nameController.text,
        lastnameController.text,
        matriculeController.text,
      );
      nameController.clear();
      lastnameController.clear();
      matriculeController.clear();
      fetchStudents();
    } catch (e) {
      print("Failed to update student: $e");
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      await ApiService.deleteStudent(id);
      fetchStudents();
    } catch (e) {
      print("Failed to delete student: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer étudiants'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${students[index]['name']} ${students[index]['lastname']}"),
                  subtitle: Text('Matricule : ${students[index]['matricule']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showEditDialog(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          confirmDeleteStudent(students[index]['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: showAddStudentDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
              child: Text(
                'Ajouter étudiant',
                style: TextStyle(color: Colors.white), // Police en blanc
              ),
            ),
          ),
        ],
      ),
    );
  }
}
