class SupabaseStudent {
  final int? id;
  final String nombre;
  final String apellidos;
  final String email;
  final String contrasena;
  final String? rol;

  SupabaseStudent(
      {this.id,
      required this.email,
      required this.nombre,
      required this.apellidos,
      required this.contrasena,
      required this.rol});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "nombre": nombre,
      "apellidos": apellidos,
      "contrasena": contrasena,
      "rol": rol
    };
  }
}
