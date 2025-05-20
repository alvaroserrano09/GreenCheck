import 'package:uuid/uuid.dart';

class Result {
  final String id;
  final DateTime dateFinished;
  final int score;
  final String idStudent;
  final String idTest;
  final String? testName;

  Result({
    required this.id,
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
    String? testName,
  }) {
    final uuid = const Uuid().v4();
    return Result(
      id: uuid,
      dateFinished: dateFinished,
      score: score,
      idStudent: idStudent,
      idTest: idTest,
      testName: testName,
    );
  }
}
