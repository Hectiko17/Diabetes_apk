import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/activity.dart';
import 'package:diabetes_apk/models/user.dart';

class ViewActivityScreen extends StatelessWidget {
  Future<Map<Activity, User>> _fetchActivityData() async {
    final activities = await DatabaseHelper.instance.getAllActivities();
    final Map<Activity, User> activityData = {};

    for (var activity in activities) {
      final user = await DatabaseHelper.instance.getUserById(activity.userId);
      if (user != null) {
        activityData[activity] = user;
      }
    }
    return activityData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Actividades'),
      ),
      body: FutureBuilder<Map<Activity, User>>(
        future: _fetchActivityData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las actividades.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay registros de actividades.'));
          } else {
            final activityData = snapshot.data!;
            return ListView.builder(
              itemCount: activityData.length,
              itemBuilder: (context, index) {
                final entry = activityData.entries.elementAt(index);
                final activity = entry.key;
                final user = entry.value;

                return ListTile(
                  title: Text('Actividad: ${activity.type}'),
                  subtitle: Text(
                    'Duración: ${activity.duration} minutos\n'
                    'Paciente: ${user.firstName} ${user.lastName}\n'
                    'Fecha: ${activity.dateTime}\n'
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
