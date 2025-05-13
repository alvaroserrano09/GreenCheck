class Result {
  final int? id;
  final DateTime dateFinished;
  final int score;
  final String idStudent;
  final String idTest;
  final String? testName;

  Result({
    this.id,
    required this.dateFinished,
    required this.score,
    required this.idStudent,
    required this.idTest,
    this.testName,
  });

  factory Result.create({
    required DateTime dateFinished,
    required int score,
    required String idStudent,
    required String idTest,
    required String testName,
  }) {
    return Result(
      dateFinished: dateFinished,
      score: score,
      idStudent: idStudent,
      idTest: idTest,
      testName: testName,
    );
  }
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      dateFinished: DateTime.parse(json['fecha_realizacion']),
      score: json['puntuacion'],
      idStudent: json['id_alumno'],
      idTest: json['id_test'],
    );
  }
}
