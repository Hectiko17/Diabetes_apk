import 'package:flutter/material.dart';

class RegisterMedicationScreen extends StatefulWidget {
  @override
  _RegisterMedicationScreenState createState() =>
      _RegisterMedicationScreenState();
}

class _RegisterMedicationScreenState extends State<RegisterMedicationScreen> {
  final TextEditingController medicationNameController =
      TextEditingController();
  final TextEditingController dosageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Medicamentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: medicationNameController,
              decoration: InputDecoration(labelText: 'Nombre del Medicamento'),
            ),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(labelText: 'Dosis'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para registrar el medicamento
              },
              child: Text('Registrar Medicamento'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Número de medicamentos registrados
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Medicamento $index'),
                    subtitle: Text('Dosis: ${index * 10}mg'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar el medicamento
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Lógica para eliminar el medicamento
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
