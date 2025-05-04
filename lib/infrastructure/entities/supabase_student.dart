class SupabaseStudent {
  final String id;
  final String nombre;
  final String apellidos;
  final String email;

  SupabaseStudent({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellidos,
  });
  Map<String, dynamic> toJsonStudent() {
    return {
      "id": id,
      "email": email,
      "nombre": nombre,
      "apellidos": apellidos,
    };
  }

  factory SupabaseStudent.fromJson(Map<String, dynamic> json) {
    return SupabaseStudent(
      id: json['id'],
      email: json['email'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
    );
  }
}
