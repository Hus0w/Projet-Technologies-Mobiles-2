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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: Colors.orangeAccent,
          onPrimary: Colors.white, // Texte blanc dans AppBar
        ),
        useMaterial3: true, // Utilisation de Material Design 3
        scaffoldBackgroundColor: Colors.grey[100], // Fond des pages
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.grey[800]),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo, // Couleur de fond de l'AppBar
          foregroundColor: Colors.white, // Texte blanc dans l'AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo, // Couleur de fond des boutons
            foregroundColor: Colors.white, // Texte blanc
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
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
        title: Text(
          "Menu Principal",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white, // Forcer le texte blanc pour l'AppBar
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentManagementPage(),
                    ),
                  );
                },
                child: Text("Gérer étudiants"),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseManagementPage(),
                    ),
                  );
                },
                child: Text("Gérer cours"),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GradeManagementPage(),
                    ),
                  );
                },
                child: Text("Gérer notes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
