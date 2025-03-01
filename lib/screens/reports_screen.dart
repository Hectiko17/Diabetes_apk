import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:diabetes_apk/models/meal.dart';
import 'package:diabetes_apk/models/medication.dart';
import 'package:diabetes_apk/models/activity.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<FlSpot> _glucoseData = [];
  List<FlSpot> _mealData = [];
  List<FlSpot> _medicationData = [];
  List<FlSpot> _activityData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final glucoseLevels = await DatabaseHelper.instance.getAllGlucoseLevels();
    final glucoseSpots = glucoseLevels.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.level);
    }).toList();

    final meals = await DatabaseHelper.instance.getAllMeals();
    final mealSpots = meals.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.calories.toDouble());
    }).toList();

    final medications = await DatabaseHelper.instance.getAllMedications();
    final medicationSpots = medications.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.dosage.length.toDouble());
    }).toList();

    final activities = await DatabaseHelper.instance.getAllActivities();
    final activitySpots = activities.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.duration.toDouble());
    }).toList();

    setState(() {
      _glucoseData = glucoseSpots;
      _mealData = mealSpots;
      _medicationData = medicationSpots;
      _activityData = activitySpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informes y Gráficos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Niveles de Glucosa (mg/dL)',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 200, child: _buildGlucoseChart()),
              SizedBox(height: 20),
              Text('Calorías de Comidas (kcal)',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 200, child: _buildMealChart()),
              SizedBox(height: 20),
              Text('Dosis de Medicamentos', style: TextStyle(fontSize: 18)),
              SizedBox(height: 200, child: _buildMedicationChart()),
              SizedBox(height: 20),
              Text('Duración de Actividades Físicas (minutos)',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 200, child: _buildActivityChart()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlucoseChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()} mg/dL');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('Día ${value.toInt()}');
              },
            ),
          ),
        ),
        borderData:
            FlBorderData(show: true, border: Border.all(color: Colors.grey)),
        lineBarsData: [
          LineChartBarData(
            spots: _glucoseData,
            isCurved: true,
            barWidth: 2,
            color: Colors.blue,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildMealChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()} kcal');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('Día ${value.toInt()}');
              },
            ),
          ),
        ),
        borderData:
            FlBorderData(show: true, border: Border.all(color: Colors.grey)),
        lineBarsData: [
          LineChartBarData(
            spots: _mealData,
            isCurved: true,
            barWidth: 2,
            color: Colors.red,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()} dosis');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('Día ${value.toInt()}');
              },
            ),
          ),
        ),
        borderData:
            FlBorderData(show: true, border: Border.all(color: Colors.grey)),
        lineBarsData: [
          LineChartBarData(
            spots: _medicationData,
            isCurved: true,
            barWidth: 2,
            color: Colors.green,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()} min');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('Día ${value.toInt()}');
              },
            ),
          ),
        ),
        borderData:
            FlBorderData(show: true, border: Border.all(color: Colors.grey)),
        lineBarsData: [
          LineChartBarData(
            spots: _activityData,
            isCurved: true,
            barWidth: 2,
            color: Colors.purple,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
