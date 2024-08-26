import 'package:flutter/material.dart';

class SyncDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sincronización de Dispositivos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Lógica para iniciar la sincronización
              },
              child: Text('Sincronizar Dispositivo'),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey[
                  200], // Espacio reservado para el estado de sincronización
              child: Center(
                child: Text('Estado de Sincronización'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
