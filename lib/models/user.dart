class User {
  final int? id;
  final String username;
  final String password;
  final String role;
  final String firstName;
  final String lastName;
  final int age;
  final double weight;
  final double height;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      role: map['role'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
    );
  }
}
