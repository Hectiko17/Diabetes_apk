import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/medication.dart';
import 'package:diabetes_apk/db/database_helper.dart';

class ViewMedicationScreen extends StatefulWidget {
  @override
  _ViewMedicationScreenState createState() => _ViewMedicationScreenState();
}

class _ViewMedicationScreenState extends State<ViewMedicationScreen> {
  late Future<List<Medication>> _medications;

  @override
  void initState() {
    super.initState();
    _medications = DatabaseHelper.instance
        .getAllMedications(); // Recupera todos los medicamentos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicamentos de Todos los Pacientes'),
      ),
      body: FutureBuilder<List<Medication>>(
        future: _medications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los medicamentos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay medicamentos registrados.'));
          } else {
            final medications = snapshot.data!;
            return ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];
                return ListTile(
                  title: Text(medication.name),
                  subtitle: Text(
                      'Paciente ID: ${medication.userId}\nDosis: ${medication.dosage}\nFecha: ${medication.dateTime}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
