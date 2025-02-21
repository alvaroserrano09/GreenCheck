class Student {
  final int? id;
  final String email;
  final String name;
  final String surname;
  final String password;

  Student({
    required this.email,
    this.id,
    required this.name,
    required this.surname,
    required this.password,
  });

  factory Student.create({
    int? id,
    required String name,
    required String surname,
    required String email,
    required String password,
  }) {
    return Student(
      email: email,
      id: id,
      name: name,
      surname: surname,
      password: password,
    );
  }
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      email: json['email'],
      name: json['nombre'],
      surname: json['apellidos'],
      password: json['contrasena'],
    );
  }
}
