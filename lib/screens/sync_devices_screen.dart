import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:intl/intl.dart';

class SyncDevicesScreen extends StatefulWidget {
  @override
  _SyncDevicesScreenState createState() => _SyncDevicesScreenState();
}

class _SyncDevicesScreenState extends State<SyncDevicesScreen> {
  bool _isSyncing = false;

  Future<void> _simulateSync() async {
    setState(() {
      _isSyncing = true;
    });

    // Simular la sincronización con un retraso
    await Future.delayed(Duration(seconds: 2));

    // Simular datos sincronizados (normalmente vendrían del dispositivo)
    final DateTime now = DateTime.now();
    final simulatedGlucoseLevel = GlucoseLevel(
      userId: 1, // Esto debería ser dinámico, asignado al usuario logueado
      level: 110.0, // Ejemplo de nivel de glucosa
      dateTime: DateFormat('yyyy-MM-dd HH:mm').format(now),
    );

    // Insertar el nivel de glucosa simulado en la base de datos
    await DatabaseHelper.instance.insertGlucoseLevel(simulatedGlucoseLevel);

    setState(() {
      _isSyncing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Sincronización completada. Datos de glucosa registrados.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sincronización con Dispositivos'),
      ),
      body: Center(
        child: _isSyncing
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _simulateSync,
                child: Text('Iniciar Sincronización'),
              ),
      ),
    );
  }
}
