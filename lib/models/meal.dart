class Meal {
  final int? id;
  final int userId;
  final String mealName;
  final int calories;
  final String dateTime;

  Meal({
    this.id,
    required this.userId,
    required this.mealName,
    required this.calories,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'mealName': mealName,
      'calories': calories,
      'dateTime': dateTime,
    };
  }

  static Meal fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      userId: map['userId'],
      mealName: map['mealName'],
      calories: map['calories'],
      dateTime: map['dateTime'],
    );
  }
}
