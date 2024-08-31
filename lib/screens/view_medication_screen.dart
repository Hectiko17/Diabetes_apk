import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/medication.dart';
import 'package:diabetes_apk/models/user.dart';

class ViewMedicationScreen extends StatelessWidget {
  Future<Map<Medication, User>> _fetchMedicationData() async {
    final medications = await DatabaseHelper.instance.getAllMedications();
    final Map<Medication, User> medicationData = {};

    for (var medication in medications) {
      final user = await DatabaseHelper.instance.getUserById(medication.userId);
      if (user != null) {
        medicationData[medication] = user;
      }
    }
    return medicationData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Medicamentos'),
      ),
      body: FutureBuilder<Map<Medication, User>>(
        future: _fetchMedicationData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los medicamentos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay registros de medicamentos.'));
          } else {
            final medicationData = snapshot.data!;
            return ListView.builder(
              itemCount: medicationData.length,
              itemBuilder: (context, index) {
                final entry = medicationData.entries.elementAt(index);
                final medication = entry.key;
                final user = entry.value;

                return ListTile(
                  title: Text('Medicamento: ${medication.name}'),
                  subtitle: Text(
                    'Dosis: ${medication.dosage}\n'
                    'Paciente: ${user.firstName} ${user.lastName}\n'
                    'Fecha: ${medication.dateTime}\n'
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
