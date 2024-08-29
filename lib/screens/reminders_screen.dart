import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/reminder.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:intl/intl.dart';

class RemindersScreen extends StatefulWidget {
  final User user;

  RemindersScreen({required this.user});

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final TextEditingController messageController = TextEditingController();
  DateTime? _selectedDateTime;
  late Future<List<Reminder>> _reminders;
  Reminder? _editingReminder;

  @override
  void initState() {
    super.initState();
    _reminders = DatabaseHelper.instance.getRemindersByUser(widget.user.id!);
  }

  void _addOrUpdateReminder() async {
    final message = messageController.text;

    if (message.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final newReminder = Reminder(
      id: _editingReminder?.id,
      userId: widget.user.id!,
      message: message,
      dateTime: DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!),
    );

    if (_editingReminder == null) {
      await DatabaseHelper.instance.insertReminder(newReminder);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recordatorio registrado exitosamente.')),
      );
    } else {
      await DatabaseHelper.instance.updateReminder(newReminder);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recordatorio actualizado exitosamente.')),
      );
    }

    setState(() {
      _reminders = DatabaseHelper.instance.getRemindersByUser(widget.user.id!);
      _editingReminder = null;
    });

    messageController.clear();
    _selectedDateTime = null;
  }

  void _startEditing(Reminder reminder) {
    setState(() {
      _editingReminder = reminder;
      messageController.text = reminder.message;
      _selectedDateTime = DateTime.parse(reminder.dateTime);
    });
  }

  void _deleteReminder(int id) async {
    await DatabaseHelper.instance.deleteReminder(id);

    setState(() {
      _reminders = DatabaseHelper.instance.getRemindersByUser(widget.user.id!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recordatorio eliminado exitosamente.')),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

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
              controller: messageController,
              decoration:
                  InputDecoration(labelText: 'Mensaje del Recordatorio'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => _selectDateTime(context),
              child: Text(
                _selectedDateTime == null
                    ? 'Seleccionar Fecha y Hora'
                    : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrUpdateReminder,
              child: Text(_editingReminder == null
                  ? 'Registrar Recordatorio'
                  : 'Actualizar Recordatorio'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Reminder>>(
                future: _reminders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error al cargar los recordatorios.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No hay recordatorios registrados.'));
                  } else {
                    final reminders = snapshot.data!;
                    return ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        return ListTile(
                          title: Text(reminder.message),
                          subtitle: Text('Fecha: ${reminder.dateTime}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _startEditing(reminder),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteReminder(reminder.id!),
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
