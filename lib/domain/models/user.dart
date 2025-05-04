import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String? role;

  User({
    required this.email,
    required this.id,
    required this.name,
    required this.surname,
    this.role,
  });

  factory User.create({
    required String name,
    required String surname,
    required String email,
    String? role,
  }) {
    final uuid = const Uuid().v4();
    return User(
        email: email, id: uuid, name: name, surname: surname, role: role);
  }
}
