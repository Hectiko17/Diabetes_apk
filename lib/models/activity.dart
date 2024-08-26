class Activity {
  final int? id;
  final int userId;
  final String type;
  final int duration;
  final DateTime dateTime;

  Activity(
      {this.id,
      required this.userId,
      required this.type,
      required this.duration,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'duration': duration,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static Activity fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      userId: map['userId'],
      type: map['type'],
      duration: map['duration'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
