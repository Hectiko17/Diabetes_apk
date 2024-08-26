import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informes y Gráficos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Lógica para generar informes
              },
              child: Text('Generar Informe'),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200], // Espacio reservado para gráficos
              child: Center(
                child: Text('Gráfico'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
