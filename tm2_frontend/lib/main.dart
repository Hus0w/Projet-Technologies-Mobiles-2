import 'package:flutter/material.dart';
import 'pages/student_management_page.dart';
import 'pages/course_management_page.dart';
import 'pages/grade_management_page.dart';
import 'pages/course_statistics_page.dart';
import 'pages/student_statistics_page.dart';
import 'splash_screen.dart';

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
          onPrimary: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.grey[800]),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: SplashScreen(), // Définit le SplashScreen comme première page
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
            color: Colors.white,
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
            SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseStatisticsPage(),
                    ),
                  );
                },
                child: Text("Statistiques des cours"),
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
                      builder: (context) => StudentStatisticsPage(),
                    ),
                  );
                },
                child: Text("Statistiques des étudiants"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
