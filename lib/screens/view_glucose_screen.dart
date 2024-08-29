import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:diabetes_apk/models/user.dart';

class ViewGlucoseScreen extends StatelessWidget {
  Future<Map<GlucoseLevel, User>> _fetchGlucoseData() async {
    final levels = await DatabaseHelper.instance.getAllGlucoseLevels();
    final Map<GlucoseLevel, User> glucoseData = {};

    for (var level in levels) {
      final user = await DatabaseHelper.instance.getUserById(level.userId);
      if (user != null) {
        glucoseData[level] = user;
      }
    }
    return glucoseData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Glucemias'),
      ),
      body: FutureBuilder<Map<GlucoseLevel, User>>(
        future: _fetchGlucoseData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las glucemias.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay registros de glucemia.'));
          } else {
            final glucoseData = snapshot.data!;
            return ListView.builder(
              itemCount: glucoseData.length,
              itemBuilder: (context, index) {
                final entry = glucoseData.entries.elementAt(index);
                final glucoseLevel = entry.key;
                final user = entry.value;

                return ListTile(
                  title: Text('Glucemia: ${glucoseLevel.level} mg/dL'),
                  subtitle: Text(
                    'Paciente: ${user.firstName} ${user.lastName}\n'
                    'Fecha: ${glucoseLevel.dateTime}\n'
                    'Edad: ${user.age} años, Peso: ${user.weight} kg, Talla: ${user.height} cm',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
