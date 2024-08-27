import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:diabetes_apk/models/user.dart';
import 'package:diabetes_apk/models/glucose_level.dart';
import 'package:diabetes_apk/models/meal.dart';
import 'package:diabetes_apk/models/medication.dart';
import 'package:diabetes_apk/models/activity.dart';
import 'package:diabetes_apk/models/reminder.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('diabetes_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      role TEXT NOT NULL,
      firstName TEXT NOT NULL,
      lastName TEXT NOT NULL,
      age INTEGER NOT NULL,
      weight REAL NOT NULL,
      height REAL NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE glucose_levels (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      level REAL NOT NULL,
      dateTime TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE meals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      mealName TEXT NOT NULL,
      calories INTEGER NOT NULL,
      dateTime TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE medications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      name TEXT NOT NULL,
      dosage TEXT NOT NULL,
      dateTime TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE activities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      type TEXT NOT NULL,
      duration INTEGER NOT NULL,
      dateTime TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE reminders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      message TEXT NOT NULL,
      dateTime TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id)
    )
    ''');

    // Crear usuario administrador predeterminado
    await db.insert('users', {
      'username': 'Hectiko',
      'password': '1417',
      'role': 'admin',
      'firstName': 'Hector',
      'lastName': 'Admin',
      'age': 35,
      'weight': 75.0,
      'height': 175.0,
    });
  }

  Future<User?> authenticateUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> insertUser(User user) async {
    final db = await instance.database;
    await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((json) => User.fromMap(json)).toList();
  }

  Future<List<User>> getUsersByRole(String role) async {
    final db = await instance.database;
    final result =
        await db.query('users', where: 'role = ?', whereArgs: [role]);
    return result.map((json) => User.fromMap(json)).toList();
  }

  Future<void> insertGlucoseLevel(GlucoseLevel level) async {
    final db = await instance.database;
    await db.insert('glucose_levels', level.toMap());
  }

  Future<List<GlucoseLevel>> getGlucoseLevels(int userId) async {
    final db = await instance.database;
    final result = await db
        .query('glucose_levels', where: 'userId = ?', whereArgs: [userId]);
    return result.map((json) => GlucoseLevel.fromMap(json)).toList();
  }

  Future<List<GlucoseLevel>> getAllGlucoseLevels() async {
    final db = await instance.database;
    final result = await db.query('glucose_levels', orderBy: 'dateTime DESC');
    return result.map((json) => GlucoseLevel.fromMap(json)).toList();
  }

  Future<User?> getUserById(int userId) async {
    final db = await instance.database;
    final result =
        await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  // --- Funcionalidades de Comidas ---

  Future<void> insertMeal(Meal meal) async {
    final db = await instance.database;
    await db.insert('meals', meal.toMap());
  }

  Future<List<Meal>> getMealsByUser(int userId) async {
    final db = await instance.database;
    final result = await db.query('meals',
        where: 'userId = ?', whereArgs: [userId], orderBy: 'dateTime DESC');
    return result.map((json) => Meal.fromMap(json)).toList();
  }

  Future<List<Meal>> getAllMeals() async {
    final db = await instance.database;
    final result = await db.query('meals', orderBy: 'dateTime DESC');
    return result.map((json) => Meal.fromMap(json)).toList();
  }

  Future<void> insertMedication(Medication medication) async {
    final db = await instance.database;
    await db.insert('medications', medication.toMap());
  }

  // Eliminar un nivel de glucemia
  Future<void> deleteGlucoseLevel(int id) async {
    final db = await instance.database;
    await db.delete('glucose_levels', where: 'id = ?', whereArgs: [id]);
  }

// Eliminar una comida
  Future<void> deleteMeal(int id) async {
    final db = await instance.database;
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

// Eliminar un medicamento
  Future<void> deleteMedication(int id) async {
    final db = await instance.database;
    await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  // Editar un nivel de glucemia
  Future<void> updateGlucoseLevel(GlucoseLevel level) async {
    final db = await instance.database;
    await db.update('glucose_levels', level.toMap(),
        where: 'id = ?', whereArgs: [level.id]);
  }

  // Insertar una actividad
  Future<void> insertActivity(Activity activity) async {
    final db = await instance.database;
    await db.insert('activities', activity.toMap());
  }

// Obtener todas las actividades de un usuario
  Future<List<Activity>> getActivitiesByUser(int userId) async {
    final db = await instance.database;
    final result = await db.query('activities',
        where: 'userId = ?', whereArgs: [userId], orderBy: 'dateTime DESC');
    return result.map((json) => Activity.fromMap(json)).toList();
  }

// Obtener todas las actividades de todos los usuarios
  Future<List<Activity>> getAllActivities() async {
    final db = await instance.database;
    final result = await db.query('activities', orderBy: 'dateTime DESC');
    return result.map((json) => Activity.fromMap(json)).toList();
  }

// Actualizar una actividad
  Future<void> updateActivity(Activity activity) async {
    final db = await instance.database;
    await db.update('activities', activity.toMap(),
        where: 'id = ?', whereArgs: [activity.id]);
  }

// Eliminar una actividad
  Future<void> deleteActivity(int id) async {
    final db = await instance.database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

// Editar una comida
  Future<void> updateMeal(Meal meal) async {
    final db = await instance.database;
    await db
        .update('meals', meal.toMap(), where: 'id = ?', whereArgs: [meal.id]);
  }

// Editar un medicamento
  Future<void> updateMedication(Medication medication) async {
    final db = await instance.database;
    await db.update('medications', medication.toMap(),
        where: 'id = ?', whereArgs: [medication.id]);
  }

  Future<List<Medication>> getMedicationsByUser(int userId) async {
    final db = await instance.database;
    final result = await db.query('medications',
        where: 'userId = ?', whereArgs: [userId], orderBy: 'dateTime DESC');
    return result.map((json) => Medication.fromMap(json)).toList();
  }

  Future<List<Medication>> getAllMedications() async {
    final db = await instance.database;
    final result = await db.query('medications', orderBy: 'dateTime DESC');
    return result.map((json) => Medication.fromMap(json)).toList();
  }
}
