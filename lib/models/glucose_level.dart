class GlucoseLevel {
  final int? id;
  final int userId;
  final double level;
  final String dateTime;

  GlucoseLevel(
      {this.id,
      required this.userId,
      required this.level,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'level': level,
      'dateTime': dateTime,
    };
  }

  static GlucoseLevel fromMap(Map<String, dynamic> map) {
    return GlucoseLevel(
      id: map['id'],
      userId: map['userId'],
      level: map['level'],
      dateTime: map['dateTime'],
    );
  }
}
