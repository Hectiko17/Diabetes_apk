import 'package:flutter/material.dart';
import 'package:diabetes_apk/models/meal.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:diabetes_apk/db/database_helper.dart';
import 'package:intl/intl.dart';

class RegisterMealScreen extends StatefulWidget {
  final User user;

  RegisterMealScreen({required this.user});

  @override
  _RegisterMealScreenState createState() => _RegisterMealScreenState();
}

class _RegisterMealScreenState extends State<RegisterMealScreen> {
  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  late Future<List<Meal>> _meals;

  @override
  void initState() {
    super.initState();
    _meals = DatabaseHelper.instance.getMealsByUser(widget.user.id!);
  }

  void _addMeal() async {
    try {
      final mealName = mealNameController.text;
      final calories = int.tryParse(caloriesController.text);

      // Validar que los campos no estén vacíos
      if (mealName.isEmpty || calories == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Por favor, completa todos los campos correctamente.')),
        );
        return;
      }

      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      final newMeal = Meal(
        userId: widget.user.id!,
        mealName: mealName,
        calories: calories,
        dateTime: formattedDate,
      );

      await DatabaseHelper.instance.insertMeal(newMeal);

      setState(() {
        _meals = DatabaseHelper.instance.getMealsByUser(widget.user.id!);
      });

      mealNameController.clear();
      caloriesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comida registrada exitosamente.')),
      );
    } catch (e) {
      print('Error al registrar la comida: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error al registrar la comida.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Comida'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: mealNameController,
              decoration: InputDecoration(labelText: 'Nombre de la Comida'),
            ),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(labelText: 'Calorías'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMeal,
              child: Text('Registrar Comida'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Meal>>(
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
                              'Calorías: ${meal.calories}\nFecha: ${meal.dateTime}'),
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
