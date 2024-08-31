import 'package:flutter/material.dart';
import 'package:diabetes_apk/screens/view_glucose_screen.dart';
import 'package:diabetes_apk/screens/view_meal_screen.dart';
import 'package:diabetes_apk/screens/view_medication_screen.dart';
import 'package:diabetes_apk/screens/view_activity_screen.dart';
import 'package:diabetes_apk/screens/view_reminders_screen.dart';
import 'package:diabetes_apk/screens/reports_screen.dart';
import 'package:diabetes_apk/screens/register_glucose_screen.dart';
import 'package:diabetes_apk/screens/register_meal_screen.dart';
import 'package:diabetes_apk/screens/register_medication_screen.dart';
import 'package:diabetes_apk/screens/register_activity_screen.dart';
import 'package:diabetes_apk/screens/reminders_screen.dart';
import 'package:diabetes_apk/screens/sync_devices_screen.dart';
import 'package:diabetes_apk/models/user.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(ViewGlucoseScreen()); // Ver y gestionar glucemias
    _screens.add(ViewMealScreen()); // Ver y gestionar comidas
    _screens.add(ViewMedicationScreen()); // Ver y gestionar medicamentos
    _screens.add(ViewActivityScreen()); // Ver y gestionar actividades
    _screens.add(ViewRemindersScreen()); // Ver y gestionar recordatorios
    _screens.add(ReportsScreen()); // Ver informes
    _screens.add(SyncDevicesScreen()); // Sincronización con dispositivos
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio del Administrador'),
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
            label: 'Glucemias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Comidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Medicamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Actividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Recordatorios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Informes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Dispositivos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black, // Fondo oscuro
        selectedItemColor: Colors.blueGrey, // Ítem seleccionado
        unselectedItemColor: Colors.grey[400],
      ),
    );
  }
}
