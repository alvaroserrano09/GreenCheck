class SupabaseResult {
  final String id;
  final DateTime fechaRealizacion;
  final int puntuacion;
  final String idAlumno;
  final String idTest;

  SupabaseResult({
    required this.id,
    required this.fechaRealizacion,
    required this.puntuacion,
    required this.idAlumno,
    required this.idTest,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_realizacion': fechaRealizacion.toIso8601String(),
      'puntuacion': puntuacion,
      'id_alumno': idAlumno,
      'id_test': idTest,
    };
  }

  factory SupabaseResult.fromJson(Map<String, dynamic> json) {
    return SupabaseResult(
      id: json['id'],
      fechaRealizacion: DateTime.parse(json['fecha_realizacion']),
      puntuacion: json['puntuacion'],
      idAlumno: json['id_alumno'],
      idTest: json['id_test'],
    );
  }
}
