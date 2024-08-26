import 'package:flutter/material.dart';

class ViewActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Actividades de Pacientes'),
      ),
      body: ListView.builder(
        itemCount: 10, // Simulación de 10 registros
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Actividad $index'),
            subtitle: Text(
                'Duración: ${index * 30} minutos\nPaciente: Paciente $index'),
          );
        },
      ),
    );
  }
}
