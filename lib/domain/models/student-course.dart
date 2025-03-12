class StudentCourse {
  final int idAlumno;
  final int idCurso;

  StudentCourse({
    required this.idAlumno,
    required this.idCurso,
  });

  factory StudentCourse.create({
    required DateTime createdAt,
    required int idAlumno,
    required int idCurso,
  }) {
    return StudentCourse(
      idAlumno: idAlumno,
      idCurso: idCurso,
    );
  }

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    return StudentCourse(
      idAlumno: json['id_alumno'],
      idCurso: json['id_curso'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alumno': idAlumno,
      'id_curso': idCurso,
    };
  }
}
