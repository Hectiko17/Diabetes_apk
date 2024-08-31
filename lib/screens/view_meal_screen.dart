import 'package:flutter/material.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:diabetes_apk/models/meal.dart';
import 'package:diabetes_apk/models/user.dart';

class ViewMealScreen extends StatelessWidget {
  Future<Map<Meal, User>> _fetchMealData() async {
    final meals = await DatabaseHelper.instance.getAllMeals();
    final Map<Meal, User> mealData = {};

    for (var meal in meals) {
      final user = await DatabaseHelper.instance.getUserById(meal.userId);
      if (user != null) {
        mealData[meal] = user;
      }
    }
    return mealData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Comidas'),
      ),
      body: FutureBuilder<Map<Meal, User>>(
        future: _fetchMealData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las comidas.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay registros de comidas.'));
          } else {
            final mealData = snapshot.data!;
            return ListView.builder(
              itemCount: mealData.length,
              itemBuilder: (context, index) {
                final entry = mealData.entries.elementAt(index);
                final meal = entry.key;
                final user = entry.value;

                return ListTile(
                  title: Text('Comida: ${meal.mealName}'),
                  subtitle: Text(
                    'Calorías: ${meal.calories}\n'
                    'Paciente: ${user.firstName} ${user.lastName}\n'
                    'Fecha: ${meal.dateTime}\n'
                    'Edad: ${user.age} años, Peso: ${user.weight} kg, Talla: ${user.height} cm',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
