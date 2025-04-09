class User {
  final int? id;
  final String email;
  final String name;
  final String surname;
  final String? role;

  User(
      {required this.email,
      this.id,
      required this.name,
      required this.surname,
      this.role});

  factory User.create(
      {int? id,
      required String name,
      required String surname,
      required String email,
      String? role}) {
    return User(email: email, id: id, name: name, surname: surname, role: role);
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        name: json['nombre'],
        surname: json['apellidos'],
        role: json['rol']);
  }
}
