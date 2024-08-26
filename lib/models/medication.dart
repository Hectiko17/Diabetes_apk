class Medication {
  final int? id;
  final int userId;
  final String name;
  final String dosage;
  final DateTime dateTime;

  Medication(
      {this.id,
      required this.userId,
      required this.name,
      required this.dosage,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'dosage': dosage,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      dosage: map['dosage'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
