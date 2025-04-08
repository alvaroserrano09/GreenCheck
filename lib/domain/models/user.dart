class User {
  final int? id;
  final String email;
  final String name;
  final String surname;
  late final String password;
  final String? role;

  User(
      {required this.email,
      this.id,
      required this.name,
      required this.surname,
      required this.password,
      this.role});

  factory User.create(
      {int? id,
      required String name,
      required String surname,
      required String email,
      required String password,
      String? role}) {
    return User(
        email: email,
        id: id,
        name: name,
        surname: surname,
        password: password,
        role: role);
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        name: json['nombre'],
        surname: json['apellidos'],
        password: json['contrasena'],
        role: json['rol']);
  }
}
