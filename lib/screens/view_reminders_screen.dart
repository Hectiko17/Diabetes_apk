import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/reminder.dart';
import 'package:diabetes_apk/models/user.dart';

class ViewRemindersScreen extends StatelessWidget {
  Future<Map<Reminder, User>> _fetchRemindersData() async {
    final reminders = await DatabaseHelper.instance.getAllReminders();
    final Map<Reminder, User> remindersData = {};

    for (var reminder in reminders) {
      final user = await DatabaseHelper.instance.getUserById(reminder.userId);
      if (user != null) {
        remindersData[reminder] = user;
      }
    }
    return remindersData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Recordatorios'),
      ),
      body: FutureBuilder<Map<Reminder, User>>(
        future: _fetchRemindersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los recordatorios.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay recordatorios registrados.'));
          } else {
            final remindersData = snapshot.data!;
            return ListView.builder(
              itemCount: remindersData.length,
              itemBuilder: (context, index) {
                final entry = remindersData.entries.elementAt(index);
                final reminder = entry.key;
                final user = entry.value;

                return ListTile(
                  title: Text('Recordatorio: ${reminder.message}'),
                  subtitle: Text(
                    'Fecha: ${reminder.dateTime}\n'
                    'Paciente: ${user.firstName} ${user.lastName}\n'
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
