import 'package:flutter/material.dart';

class ViewRemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Recordatorios de Pacientes'),
      ),
      body: ListView.builder(
        itemCount: 10, // Simulación de 10 registros
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Recordatorio $index'),
            subtitle: Text(
                'Fecha y Hora: ${index * 10}:00\nPaciente: Paciente $index'),
          );
        },
      ),
    );
  }
}
