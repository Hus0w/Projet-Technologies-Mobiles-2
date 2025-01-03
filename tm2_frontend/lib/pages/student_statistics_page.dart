import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class StudentStatisticsPage extends StatefulWidget {
  @override
  _StudentStatisticsPageState createState() => _StudentStatisticsPageState();
}

class _StudentStatisticsPageState extends State<StudentStatisticsPage> {
  final ApiService apiService = ApiService();
  List<dynamic> students = [];
  double? studentAverage;
  String? selectedStudentName;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des étudiants")),
      );
    }
  }

  Future<void> fetchStudentAverage(int studentId, String studentName) async {
    try {
      final average = await apiService.getStudentAverage(studentId);
      setState(() {
        studentAverage = average;
        selectedStudentName = studentName;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement de la moyenne")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          studentAverage == null ? "Liste des étudiants" : "Statistiques de l'étudiant",
        ),
        leading: studentAverage != null
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              studentAverage = null;
              selectedStudentName = null;
            });
          },
        )
            : null,
      ),
      body: studentAverage == null
          ? students.isEmpty
          ? Center(
        child: Text(
          "Aucune statistique n'est disponible",
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
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                "${student['name']} ${student['lastname']}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.bar_chart,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () => fetchStudentAverage(
                student['id'],
                "${student['name']} ${student['lastname']}",
              ),
            ),
          );
        },
      )
          : buildAverageChart(),
    );
  }

  Widget buildAverageChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Moyenne de : $selectedStudentName",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: studentAverage ?? 0.0,
                        width: 40,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
