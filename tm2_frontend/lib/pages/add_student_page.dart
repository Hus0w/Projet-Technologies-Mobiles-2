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

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      // Assurez-vous que les étudiants sont explicitement convertis en List<Map<String, dynamic>>
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
    if (selectedStudent == null || gradeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner un étudiant et entrer une note')),
      );
      return;
    }

    try {
      await apiService.addGrade(
        widget.courseId,
        selectedStudent!['id'],
        double.parse(gradeController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Étudiant ajouté avec succès')));
      Navigator.pop(context, true); // Retourner à la page précédente avec un succès
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return ListTile(
                    title: Text('${student['name']} ${student['lastname']}'),
                    subtitle: Text('Matricule : ${student['matricule']}'),
                    trailing: selectedStudent != null && selectedStudent!['id'] == student['id']
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedStudent = student;
                      });
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addStudent,
              child: Text('Ajouter l\'étudiant'),
            ),
          ],
        ),
      ),
    );
  }
}
