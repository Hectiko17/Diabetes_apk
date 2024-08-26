class Reminder {
  final int? id;
  final int userId;
  final String message;
  final DateTime dateTime;

  Reminder(
      {this.id,
      required this.userId,
      required this.message,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      userId: map['userId'],
      message: map['message'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
