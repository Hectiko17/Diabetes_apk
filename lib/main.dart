import 'package:flutter/material.dart';
import 'package:diabetes_apk/screens/login_screen.dart';
import 'package:diabetes_apk/screens/register_screen.dart';
import 'package:diabetes_apk/screens/admin_home_screen.dart';
import 'package:diabetes_apk/screens/doctor_home_screen.dart';
import 'package:diabetes_apk/screens/patient_home_screen.dart';
import 'package:diabetes_apk/screens/register_activity_screen.dart';
import 'package:diabetes_apk/screens/reports_screen.dart';
import 'package:diabetes_apk/screens/reminders_screen.dart';
import 'package:diabetes_apk/screens/sync_devices_screen.dart';
import 'package:diabetes_apk/screens/view_glucose_screen.dart';
import 'package:diabetes_apk/screens/view_meal_screen.dart';
import 'package:diabetes_apk/screens/view_medication_screen.dart';
import 'package:diabetes_apk/screens/view_activity_screen.dart';
import 'package:diabetes_apk/screens/view_reminders_screen.dart';
import 'package:diabetes_apk/models/user.dart';

void main() {
  runApp(DiabetesApk());
}

class DiabetesApk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Apk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/adminHome': (context) => AdminHomeScreen(),
        '/doctorHome': (context) => DoctorHomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/patientHome') {
          final User user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) {
              return PatientHomeScreen(user: user);
            },
          );
        }
        return null;
      },
    );
  }
}
