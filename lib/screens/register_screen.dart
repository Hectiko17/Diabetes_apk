import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String role = 'patient';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Tamaño (cm)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: role,
              onChanged: (String? newValue) {
                setState(() {
                  role = newValue!;
                });
              },
              items: <String>['patient', 'doctor']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;
                final firstName = firstNameController.text;
                final lastName = lastNameController.text;
                final age = int.parse(ageController.text);
                final weight = double.parse(weightController.text);
                final height = double.parse(heightController.text);

                final newUser = User(
                  username: username,
                  password: password,
                  role: role,
                  firstName: firstName,
                  lastName: lastName,
                  age: age,
                  weight: weight,
                  height: height,
                );

                await DatabaseHelper.instance.insertUser(newUser);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
