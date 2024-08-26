import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:diabetes_apk/screens/register_glucose_screen.dart';
import 'package:diabetes_apk/screens/register_meal_screen.dart';
import 'package:diabetes_apk/screens/register_medication_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  final User user;

  PatientHomeScreen({required this.user});

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(RegisterGlucoseScreen(user: widget.user));
    _screens.add(RegisterMealScreen(user: widget.user));
    _screens.add(RegisterMedicationScreen(user: widget.user));
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
        title: Text('Inicio del Paciente'),
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
            label: 'Glucemia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Comidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medicamentos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueGrey[900], // Fondo oscuro
        selectedItemColor: Colors.white, // Ítem seleccionado en blanco
        unselectedItemColor: Colors.grey[400],
      ),
    );
  }
}
