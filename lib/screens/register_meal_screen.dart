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
  Meal? _editingMeal; // Variable para mantener la comida que se está editando

  @override
  void initState() {
    super.initState();
    _meals = DatabaseHelper.instance.getMealsByUser(widget.user.id!);
  }

  void _addOrUpdateMeal() async {
    final mealName = mealNameController.text;
    final calories = int.tryParse(caloriesController.text);

    if (mealName.isEmpty || calories == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final newMeal = Meal(
      id: _editingMeal?.id,
      userId: widget.user.id!,
      mealName: mealName,
      calories: calories,
      dateTime: _editingMeal?.dateTime ??
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    );

    if (_editingMeal == null) {
      await DatabaseHelper.instance.insertMeal(newMeal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comida registrada exitosamente.')),
      );
    } else {
      await DatabaseHelper.instance.updateMeal(newMeal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comida actualizada exitosamente.')),
      );
    }

    setState(() {
      _meals = DatabaseHelper.instance.getMealsByUser(widget.user.id!);
      _editingMeal = null; // Restablecer la variable de edición
    });

    mealNameController.clear();
    caloriesController.clear();
  }

  void _startEditing(Meal meal) {
    setState(() {
      _editingMeal = meal;
      mealNameController.text = meal.mealName;
      caloriesController.text = meal.calories.toString();
    });
  }

  void _deleteMeal(int id) async {
    await DatabaseHelper.instance.deleteMeal(id);

    setState(() {
      _meals = DatabaseHelper.instance.getMealsByUser(widget.user.id!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comida eliminada exitosamente.')),
    );
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
              onPressed: _addOrUpdateMeal,
              child: Text(_editingMeal == null
                  ? 'Registrar Comida'
                  : 'Actualizar Comida'),
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _startEditing(meal),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteMeal(meal.id!),
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
