class SupabaseStudentCourse {
  final String id;
  final String idCurso;
  final String idAlumno;
  final bool favorito;

  SupabaseStudentCourse({
    required this.id,
    required this.idCurso,
    required this.idAlumno,
    required this.favorito,
  });

  factory SupabaseStudentCourse.fromJson(Map<String, dynamic> json) {
    return SupabaseStudentCourse(
      id: json['id'] as String,
      idCurso: json['id_curso'] as String,
      idAlumno: json['id_alumno'] as String,
      favorito: json['favorito'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_curso': idCurso,
      'id_alumno': idAlumno,
      'favorito': favorito,
    };
  }
}
