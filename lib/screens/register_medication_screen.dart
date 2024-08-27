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
  Medication?
      _editingMedication; // Variable para mantener el medicamento que se está editando

  @override
  void initState() {
    super.initState();
    _medications =
        DatabaseHelper.instance.getMedicationsByUser(widget.user.id!);
  }

  void _addOrUpdateMedication() async {
    final name = nameController.text;
    final dosage = dosageController.text;

    if (name.isEmpty || dosage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final newMedication = Medication(
      id: _editingMedication?.id,
      userId: widget.user.id!,
      name: name,
      dosage: dosage,
      dateTime: _editingMedication?.dateTime ??
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    );

    if (_editingMedication == null) {
      await DatabaseHelper.instance.insertMedication(newMedication);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicamento registrado exitosamente.')),
      );
    } else {
      await DatabaseHelper.instance.updateMedication(newMedication);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicamento actualizado exitosamente.')),
      );
    }

    setState(() {
      _medications =
          DatabaseHelper.instance.getMedicationsByUser(widget.user.id!);
      _editingMedication = null; // Restablecer la variable de edición
    });

    nameController.clear();
    dosageController.clear();
  }

  void _startEditing(Medication medication) {
    setState(() {
      _editingMedication = medication;
      nameController.text = medication.name;
      dosageController.text = medication.dosage;
    });
  }

  void _deleteMedication(int id) async {
    await DatabaseHelper.instance.deleteMedication(id);

    setState(() {
      _medications =
          DatabaseHelper.instance.getMedicationsByUser(widget.user.id!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medicamento eliminado exitosamente.')),
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
              onPressed: _addOrUpdateMedication,
              child: Text(_editingMedication == null
                  ? 'Registrar Medicamento'
                  : 'Actualizar Medicamento'),
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _startEditing(medication),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteMedication(medication.id!),
                              ),
                            ],
                          ),
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
