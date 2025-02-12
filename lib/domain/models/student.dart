class Student {
  final int id;
  final String email;
  final String name;
  final String surname;
  final String password;

  Student({
    required this.email,
    required this.id,
    required this.name,
    required this.surname,
    required this.password,
  });

  factory Student.create({
    required int id,
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
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "nombre": name,
      "apellidos": surname,
      "contrasena": password,
    };
  }
}
