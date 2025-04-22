class Result {
  final int? id;
  final DateTime dateFinished;
  final double score;
  final int idStudent;
  final int idTest;

  Result({
    this.id,
    required this.dateFinished,
    required this.score,
    required this.idStudent,
    required this.idTest,
  });

  factory Result.create({
    required DateTime dateFinished,
    required double score,
    required int idStudent,
    required int idTest,
  }) {
    return Result(
      dateFinished: dateFinished,
      score: score,
      idStudent: idStudent,
      idTest: idTest,
    );
  }
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      dateFinished: DateTime.parse(json['fecha_finalizado']),
      score: json['puntuacion'],
      idStudent: json['id_alumno'],
      idTest: json['id_test'],
    );
  }
}
