import 'package:flutter/material.dart';
import 'pages/student_management_page.dart';
import 'pages/course_management_page.dart';
import 'pages/grade_management_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des étudiants, cours et notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Principal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentManagementPage()),
                );
              },
              child: Text("Gérer étudiants"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CourseManagementPage()),
                );
              },
              child: Text("Gérer cours"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GradeManagementPage()),
                );
              },
              child: Text("Gérer notes"),
            ),
          ],
        ),
      ),
    );
  }
}
