import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:diabetes_apk/models/user.dart';

class ViewGlucoseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Glucemias de Pacientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<GlucoseLevel>>(
          future: DatabaseHelper.instance.getAllGlucoseLevels(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final levels = snapshot.data!;
              return ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  return FutureBuilder<User?>(
                    future: DatabaseHelper.instance.getUserById(level.userId),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        final user = userSnapshot.data!;
                        return ListTile(
                          title: Text('Nivel: ${level.level}'),
                          subtitle: Text(
                            'Usuario: ${user.firstName} ${user.lastName}\nFecha: ${level.dateTime}',
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
