import 'package:flutter/material.dart';
import 'package:tm2_frontend/services/api_service.dart';

class AddStudentPage extends StatefulWidget {
  final int courseId;
  final List<int> existingStudentIds;

  AddStudentPage({required this.courseId, required this.existingStudentIds});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  List<Map<String, dynamic>> allStudents = [];
  List<Map<String, dynamic>> filteredStudents = [];
  Map<String, dynamic>? selectedStudent;

  String gradeErrorMessage = ""; // Pour gérer les messages d'erreur

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final List<dynamic> students = await apiService.getStudents();
      setState(() {
        allStudents = students
            .map((student) => student as Map<String, dynamic>)
            .where((student) => !widget.existingStudentIds.contains(student['id']))
            .toList();
        filteredStudents = List.from(allStudents);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des étudiants')),
      );
    }
  }

  void filterStudents(String query) {
    setState(() {
      filteredStudents = allStudents
          .where((student) =>
      student['name'].toLowerCase().contains(query.toLowerCase()) ||
          student['lastname'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> addStudent() async {
    final String gradeText = gradeController.text;

    // Validation des champs
    if (selectedStudent == null || gradeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner un étudiant et entrer une note')),
      );
      return;
    }

    final double? grade = double.tryParse(gradeText);
    if (grade == null || grade < 0 || grade > 20) {
      setState(() {
        gradeErrorMessage = "La note doit être comprise entre 0 et 20.";
      });
      return;
    }

    try {
      await apiService.addGrade(
        widget.courseId,
        selectedStudent!['id'],
        grade,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Étudiant ajouté avec succès')));
      Navigator.pop(context, true); // Retourner à la page précédente avec succès
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de l\'étudiant')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un étudiant'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: filterStudents,
              decoration: InputDecoration(
                labelText: 'Rechercher un étudiant',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredStudents.isEmpty
                  ? Center(
                child: Text(
                  "Aucun étudiant trouvé.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        '${student['name']} ${student['lastname']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                          'Matricule : ${student['matricule']}',
                          style: TextStyle(
                              color:
                              Theme.of(context).colorScheme.secondary)),
                      trailing: selectedStudent != null &&
                          selectedStudent!['id'] == student['id']
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedStudent = student;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
                errorText: gradeErrorMessage.isNotEmpty ? gradeErrorMessage : null,
              ),
              onChanged: (_) {
                setState(() {
                  gradeErrorMessage = ""; // Efface le message d'erreur lors de la saisie
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: addStudent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add),
                  SizedBox(width: 8),
                  Text('Ajouter l\'étudiant'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
