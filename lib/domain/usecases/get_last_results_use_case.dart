import 'package:green_check/domain/models/result.dart';
import 'package:green_check/infrastructure/repositories/result_repository.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';

class GetLastResultsUseCase {
  final ResultRepository resultRepository;
  final TestRepository testRepository;

  GetLastResultsUseCase(
    this.resultRepository,
    this.testRepository,
  );

  Future<List<Result>> execute(String studentId) async {
    try {
      final results = await resultRepository.getResultsByStudentId(studentId);
      if (results.isEmpty) return [];

      final testIds =
          results.map((test) => test.idTest).whereType<int>().toSet().toList();
      if (testIds.isEmpty) return results;
      final tests = await testRepository.getTestsByIds(testIds);

      final testNameMap = {for (var test in tests) test.id: test.title};

      final resultList = results.map<Result>((results) {
        return Result(
          id: results.id,
          idTest: results.idTest,
          dateFinished: results.dateFinished,
          idStudent: results.idStudent,
          score: results.score,
          testName: testNameMap[results.idTest],
        );
      }).toList();

      return resultList;
    } catch (e) {
      rethrow;
    }
  }
}
