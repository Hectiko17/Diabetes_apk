import 'package:flutter/material.dart';
import 'package:diabetes_apk/screens/view_glucose_screen.dart';
import 'package:diabetes_apk/screens/view_meal_screen.dart';
import 'package:diabetes_apk/screens/view_medication_screen.dart';
import 'package:diabetes_apk/screens/view_activity_screen.dart';
import 'package:diabetes_apk/screens/view_reminders_screen.dart';
import 'package:diabetes_apk/screens/reports_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ViewGlucoseScreen(), // Pantalla para ver los niveles de glucemia
    ViewMealScreen(), // Pantalla para ver las comidas
    ViewMedicationScreen(), // Pantalla para ver los medicamentos
    ViewActivityScreen(), // Pantalla para ver las actividades físicas
    ViewRemindersScreen(), // Pantalla para ver los recordatorios
    ReportsScreen(), // Pantalla para ver los informes
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio del Médico'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'Ver Glucemias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Ver Comidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Ver Medicamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Ver Actividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Ver Recordatorios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Informes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black, // Fondo oscuro
        selectedItemColor: Colors.blueGrey, // Ítem seleccionado en blanco
        unselectedItemColor: Colors.grey[400],
      ),
    );
  }
}
