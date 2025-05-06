class SupabaseCourse {
  final String id;
  final String nombre;
  final String descripcion;
  final String tipo;
  final String idProfesor;

  SupabaseCourse({
    required this.id,
    required this.descripcion,
    required this.nombre,
    required this.tipo,
    required this.idProfesor,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "nombre": nombre,
      "tipo": tipo,
      "id_profesor": idProfesor,
    };
  }

  factory SupabaseCourse.fromJson(Map<String, dynamic> json) {
    return SupabaseCourse(
      id: json['id'],
      descripcion: json['descripcion'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      idProfesor: json['id_profesor'],
    );
  }
}
