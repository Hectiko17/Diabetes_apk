import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/activity.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:intl/intl.dart';

class RegisterActivityScreen extends StatefulWidget {
  final User user;

  RegisterActivityScreen({required this.user});

  @override
  _RegisterActivityScreenState createState() => _RegisterActivityScreenState();
}

class _RegisterActivityScreenState extends State<RegisterActivityScreen> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  late Future<List<Activity>> _activities;
  Activity? _editingActivity;

  @override
  void initState() {
    super.initState();
    _activities = DatabaseHelper.instance.getActivitiesByUser(widget.user.id!);
  }

  void _addOrUpdateActivity() async {
    final type = typeController.text;
    final duration = int.tryParse(durationController.text);

    if (type.isEmpty || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final newActivity = Activity(
      id: _editingActivity?.id,
      userId: widget.user.id!,
      type: type,
      duration: duration,
      dateTime: _editingActivity?.dateTime ??
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    );

    if (_editingActivity == null) {
      await DatabaseHelper.instance.insertActivity(newActivity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actividad registrada exitosamente.')),
      );
    } else {
      await DatabaseHelper.instance.updateActivity(newActivity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actividad actualizada exitosamente.')),
      );
    }

    setState(() {
      _activities =
          DatabaseHelper.instance.getActivitiesByUser(widget.user.id!);
      _editingActivity = null;
    });

    typeController.clear();
    durationController.clear();
  }

  void _startEditing(Activity activity) {
    setState(() {
      _editingActivity = activity;
      typeController.text = activity.type;
      durationController.text = activity.duration.toString();
    });
  }

  void _deleteActivity(int id) async {
    await DatabaseHelper.instance.deleteActivity(id);

    setState(() {
      _activities =
          DatabaseHelper.instance.getActivitiesByUser(widget.user.id!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Actividad eliminada exitosamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Actividad Física'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Tipo de Actividad'),
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: 'Duración (minutos)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrUpdateActivity,
              child: Text(_editingActivity == null
                  ? 'Registrar Actividad'
                  : 'Actualizar Actividad'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Activity>>(
                future: _activities,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error al cargar las actividades.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No hay actividades registradas.'));
                  } else {
                    final activities = snapshot.data!;
                    return ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return ListTile(
                          title: Text(activity.type),
                          subtitle: Text(
                              'Duración: ${activity.duration} minutos\nFecha: ${activity.dateTime}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _startEditing(activity),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteActivity(activity.id!),
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
