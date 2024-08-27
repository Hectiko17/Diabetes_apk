import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:diabetes_apk/db/database_helper.dart';

class ViewGlucoseScreen extends StatefulWidget {
  @override
  _ViewGlucoseScreenState createState() => _ViewGlucoseScreenState();
}

class _ViewGlucoseScreenState extends State<ViewGlucoseScreen> {
  late Future<List<GlucoseLevel>> _glucoseLevels;

  @override
  void initState() {
    super.initState();
    _glucoseLevels = DatabaseHelper.instance
        .getAllGlucoseLevels(); // Recupera todos los niveles de glucosa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Niveles de Glucemia de Todos los Pacientes'),
      ),
      body: FutureBuilder<List<GlucoseLevel>>(
        future: _glucoseLevels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar los niveles de glucosa.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No hay niveles de glucosa registrados.'));
          } else {
            final levels = snapshot.data!;
            return ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return ListTile(
                  title: Text('Nivel: ${level.level}'),
                  subtitle: Text(
                      'Paciente ID: ${level.userId}\nFecha: ${level.dateTime}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
