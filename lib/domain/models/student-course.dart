class StudentCourse {
  final int idAlumno;
  final int idCurso;
  bool isFavorite;

  StudentCourse({
    required this.idAlumno,
    required this.idCurso,
    this.isFavorite = false,
  });

  factory StudentCourse.create({
    required DateTime createdAt,
    required int idAlumno,
    required int idCurso,
  }) {
    return StudentCourse(
      idAlumno: idAlumno,
      idCurso: idCurso,
      isFavorite: false,
    );
  }

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    return StudentCourse(
      idAlumno: json['id_alumno'],
      idCurso: json['id_curso'],
      isFavorite: json['favorito'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alumno': idAlumno,
      'id_curso': idCurso,
      'favorito': isFavorite,
    };
  }
}
