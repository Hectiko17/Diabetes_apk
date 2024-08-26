import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final TextEditingController reminderMessageController =
      TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: reminderMessageController,
              decoration:
                  InputDecoration(labelText: 'Mensaje del Recordatorio'),
            ),
            TextField(
              controller: dateTimeController,
              decoration: InputDecoration(labelText: 'Fecha y Hora'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para registrar el recordatorio
              },
              child: Text('Añadir Recordatorio'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Número de recordatorios
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Recordatorio $index'),
                    subtitle: Text('Fecha y Hora: ${index * 10}:00'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar el recordatorio
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Lógica para eliminar el recordatorio
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
