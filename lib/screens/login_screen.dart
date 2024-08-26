import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/user.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;
                final user = await DatabaseHelper.instance
                    .authenticateUser(username, password);
                if (user != null) {
                  if (user.role == 'admin') {
                    Navigator.pushReplacementNamed(context, '/adminHome');
                  } else if (user.role == 'doctor') {
                    Navigator.pushReplacementNamed(context, '/doctorHome');
                  } else if (user.role == 'patient') {
                    Navigator.pushReplacementNamed(
                      context,
                      '/patientHome',
                      arguments: user,
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuario o contraseña incorrectos')),
                  );
                }
              },
              child: Text('Iniciar sesión'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
