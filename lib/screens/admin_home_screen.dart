import 'package:flutter/material.dart';
import 'package:diabetes_apk/screens/view_glucose_screen.dart';
import 'package:diabetes_apk/screens/register_meal_screen.dart';
import 'package:diabetes_apk/screens/register_medication_screen.dart';
import 'package:diabetes_apk/screens/register_activity_screen.dart';
import 'package:diabetes_apk/screens/reminders_screen.dart';
import 'package:diabetes_apk/screens/reports_screen.dart';
import 'package:diabetes_apk/screens/sync_devices_screen.dart';
import 'package:diabetes_apk/models/user.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  // Puedes usar un usuario predeterminado como el administrador
  final User adminUser = User(
    id: 1,
    username: 'Hectiko',
    password: '1417',
    role: 'admin',
    firstName: 'Hector',
    lastName: 'Admin',
    age: 35,
    weight: 75.0,
    height: 175.0,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterMealScreen(user: adminUser),
          ),
        );
      }
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
      body: Center(
        child: Text('Selecciona una opción del menú.',
            style: TextStyle(fontSize: 18)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'Ver Glucemias',
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
        backgroundColor: Colors.blueGrey[900], // Fondo oscuro
        selectedItemColor: Colors.white, // Ítem seleccionado en blanco
        unselectedItemColor:
            Colors.grey[400], // Ítems no seleccionados en gris claro
      ),
    );
  }
}
