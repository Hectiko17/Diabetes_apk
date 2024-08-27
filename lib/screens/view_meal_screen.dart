import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/meal.dart';
import 'package:diabetes_apk/db/database_helper.dart';

class ViewMealScreen extends StatefulWidget {
  @override
  _ViewMealScreenState createState() => _ViewMealScreenState();
}

class _ViewMealScreenState extends State<ViewMealScreen> {
  late Future<List<Meal>> _meals;

  @override
  void initState() {
    super.initState();
    _meals =
        DatabaseHelper.instance.getAllMeals(); // Recupera todas las comidas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comidas de Todos los Pacientes'),
      ),
      body: FutureBuilder<List<Meal>>(
        future: _meals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las comidas.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay comidas registradas.'));
          } else {
            final meals = snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return ListTile(
                  title: Text(meal.mealName),
                  subtitle: Text(
                      'Paciente ID: ${meal.userId}\nCalorías: ${meal.calories}\nFecha: ${meal.dateTime}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
