import 'package:flutter/material.dart';

class ViewMealScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Comidas de Pacientes'),
      ),
      body: ListView.builder(
        itemCount: 10, // Simulación de 10 registros
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Comida $index'),
            subtitle:
                Text('Calorías: ${index * 100}\nPaciente: Paciente $index'),
          );
        },
      ),
    );
  }
}
