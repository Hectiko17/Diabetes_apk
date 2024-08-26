import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:intl/intl.dart';

class RegisterGlucoseScreen extends StatefulWidget {
  final User user;

  RegisterGlucoseScreen({required this.user});

  @override
  _RegisterGlucoseScreenState createState() => _RegisterGlucoseScreenState();
}

class _RegisterGlucoseScreenState extends State<RegisterGlucoseScreen> {
  final TextEditingController glucoseController = TextEditingController();

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
              controller: glucoseController,
              decoration: InputDecoration(labelText: 'Nivel de Glucemia'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final level = double.parse(glucoseController.text);
                final dateTime =
                    DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
                final newGlucoseLevel = GlucoseLevel(
                  userId: widget.user.id!,
                  level: level,
                  dateTime: dateTime,
                );
                await DatabaseHelper.instance
                    .insertGlucoseLevel(newGlucoseLevel);
                setState(() {});
              },
              child: Text('Registrar'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<GlucoseLevel>>(
                future:
                    DatabaseHelper.instance.getGlucoseLevels(widget.user.id!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    final levels = snapshot.data!;
                    return ListView.builder(
                      itemCount: levels.length,
                      itemBuilder: (context, index) {
                        final level = levels[index];
                        return ListTile(
                          title: Text('Nivel: ${level.level}'),
                          subtitle: Text('Fecha: ${level.dateTime}'),
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
