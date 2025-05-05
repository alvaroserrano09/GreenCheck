class SupabaseTeacher {
  final String id;
  final String nombre;
  final String apellidos;
  final String email;

  SupabaseTeacher({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellidos,
  });
  Map<String, dynamic> toJsonTeacher() {
    return {
      "id": id,
      "email": email,
      "nombre": nombre,
      "apellidos": apellidos,
    };
  }

  factory SupabaseTeacher.fromJson(Map<String, dynamic> json) {
    return SupabaseTeacher(
      id: json['id'],
      email: json['email'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
    );
  }
}
