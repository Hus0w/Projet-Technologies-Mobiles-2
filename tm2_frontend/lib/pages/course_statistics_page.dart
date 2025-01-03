import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class CourseStatisticsPage extends StatefulWidget {
  @override
  _CourseStatisticsPageState createState() => _CourseStatisticsPageState();
}

class _CourseStatisticsPageState extends State<CourseStatisticsPage> {
  final ApiService apiService = ApiService();
  List<dynamic> courses = [];
  Map<String, dynamic>? selectedCourseStatistics;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des cours")),
      );
    }
  }

  Future<void> fetchCourseStatistics(int courseId) async {
    try {
      final statistics = await apiService.getCourseStatistics(courseId);
      setState(() {
        selectedCourseStatistics = statistics;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des statistiques")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCourseStatistics == null
            ? "Liste des cours"
            : "Statistiques des cours"),
        leading: selectedCourseStatistics != null
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedCourseStatistics = null;
            });
          },
        )
            : null,
      ),
      body: selectedCourseStatistics == null
          ? courses.isEmpty
          ? Center(
        child: Text(
          "Aucune statistique n'est disponible.",
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
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                course['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(
                Icons.bar_chart,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () => fetchCourseStatistics(course['id']),
            ),
          );
        },
      )
          : buildStatisticsView(),
    );
  }

  Widget buildStatisticsView() {
    final averageGrade = selectedCourseStatistics!['averageGrade'];
    final minGrade = selectedCourseStatistics!['minGrade'];
    final maxGrade = selectedCourseStatistics!['maxGrade'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Statistiques du cours : ${selectedCourseStatistics!['courseName']}",
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
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: averageGrade.toDouble(),
                        width: 16,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: minGrade.toDouble(),
                        width: 16,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: maxGrade.toDouble(),
                        width: 16,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (double value, _) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, _) {
                        if (value == 1) return Text("Moyenne");
                        if (value == 2) return Text("Min");
                        if (value == 3) return Text("Max");
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
