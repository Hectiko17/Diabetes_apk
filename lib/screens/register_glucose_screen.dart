import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:intl/intl.dart';

class RegisterGlucoseScreen extends StatefulWidget {
  final User user;

  RegisterGlucoseScreen({required this.user});

  @override
  _RegisterGlucoseScreenState createState() => _RegisterGlucoseScreenState();
}

class _RegisterGlucoseScreenState extends State<RegisterGlucoseScreen> {
  final TextEditingController levelController = TextEditingController();
  late Future<List<GlucoseLevel>> _glucoseLevels;
  GlucoseLevel?
      _editingLevel; // Variable para mantener el nivel que se está editando

  @override
  void initState() {
    super.initState();
    _glucoseLevels = DatabaseHelper.instance.getGlucoseLevels(widget.user.id!);
  }

  void _addOrUpdateGlucoseLevel() async {
    final glucoseLevel = double.tryParse(levelController.text);

    if (glucoseLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor, ingresa un nivel de glucosa válido.')),
      );
      return;
    }

    final newLevel = GlucoseLevel(
      id: _editingLevel?.id,
      userId: widget.user.id!,
      level: glucoseLevel,
      dateTime: _editingLevel?.dateTime ??
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    );

    if (_editingLevel == null) {
      await DatabaseHelper.instance.insertGlucoseLevel(newLevel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Glucemia registrada exitosamente.')),
      );
    } else {
      await DatabaseHelper.instance.updateGlucoseLevel(newLevel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Glucemia actualizada exitosamente.')),
      );
    }

    setState(() {
      _glucoseLevels =
          DatabaseHelper.instance.getGlucoseLevels(widget.user.id!);
      _editingLevel = null; // Restablecer la variable de edición
    });

    levelController.clear();
  }

  void _startEditing(GlucoseLevel level) {
    setState(() {
      _editingLevel = level;
      levelController.text = level.level.toString();
    });
  }

  void _deleteGlucoseLevel(int id) async {
    await DatabaseHelper.instance.deleteGlucoseLevel(id);

    setState(() {
      _glucoseLevels =
          DatabaseHelper.instance.getGlucoseLevels(widget.user.id!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Glucemia eliminada exitosamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Glucemia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: levelController,
              decoration: InputDecoration(labelText: 'Nivel de Glucosa'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrUpdateGlucoseLevel,
              child: Text(_editingLevel == null
                  ? 'Registrar Glucemia'
                  : 'Actualizar Glucemia'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<GlucoseLevel>>(
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
                          subtitle: Text('Fecha: ${level.dateTime}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _startEditing(level),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteGlucoseLevel(level.id!),
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
