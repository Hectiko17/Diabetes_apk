import 'package:flutter/material.dart';

class RegisterActivityScreen extends StatefulWidget {
  @override
  _RegisterActivityScreenState createState() => _RegisterActivityScreenState();
}

class _RegisterActivityScreenState extends State<RegisterActivityScreen> {
  final TextEditingController activityTypeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Actividades Físicas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: activityTypeController,
              decoration: InputDecoration(labelText: 'Tipo de Actividad'),
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: 'Duración (minutos)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para registrar la actividad física
              },
              child: Text('Registrar Actividad'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Número de actividades registradas
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Actividad $index'),
                    subtitle: Text('Duración: ${index * 30} minutos'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar la actividad
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Lógica para eliminar la actividad
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
