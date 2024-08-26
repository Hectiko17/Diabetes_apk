import 'package:flutter/material.dart';

class ViewMedicationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Medicamentos de Pacientes'),
      ),
      body: ListView.builder(
        itemCount: 10, // Simulación de 10 registros
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Medicamento $index'),
            subtitle: Text('Dosis: ${index * 10}mg\nPaciente: Paciente $index'),
          );
        },
      ),
    );
  }
}
