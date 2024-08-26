import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/medication.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:intl/intl.dart';

class RegisterMedicationScreen extends StatefulWidget {
  final User user;

  RegisterMedicationScreen({required this.user});

  @override
  _RegisterMedicationScreenState createState() =>
      _RegisterMedicationScreenState();
}

class _RegisterMedicationScreenState extends State<RegisterMedicationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  late Future<List<Medication>> _medications;

  @override
  void initState() {
    super.initState();
    _medications =
        DatabaseHelper.instance.getMedicationsByUser(widget.user.id!);
  }

  void _addMedication() async {
    final name = nameController.text;
    final dosage = dosageController.text;
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    if (name.isEmpty || dosage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final newMedication = Medication(
      userId: widget.user.id!,
      name: name,
      dosage: dosage,
      dateTime: formattedDate,
    );

    await DatabaseHelper.instance.insertMedication(newMedication);

    setState(() {
      _medications =
          DatabaseHelper.instance.getMedicationsByUser(widget.user.id!);
    });

    nameController.clear();
    dosageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medicamento registrado exitosamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre del Medicamento'),
            ),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(labelText: 'Dosis'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMedication,
              child: Text('Registrar Medicamento'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Medication>>(
                future: _medications,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error al cargar los medicamentos.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No hay medicamentos registrados.'));
                  } else {
                    final medications = snapshot.data!;
                    return ListView.builder(
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final medication = medications[index];
                        return ListTile(
                          title: Text(medication.name),
                          subtitle: Text(
                              'Dosis: ${medication.dosage}\nFecha: ${medication.dateTime}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
