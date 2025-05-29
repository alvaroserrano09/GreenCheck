import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/models/result.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/domain/usecases/get_last_results_use_case.dart';
import 'package:green_check/infrastructure/repositories/result_repository.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'get_last_results_use_case_test.mocks.dart';

@GenerateMocks([ResultRepository, TestRepository])
void main() {
  late GetLastResultsUseCase getLastResultsUseCase;
  late MockResultRepository mockResultRepository;
  late MockTestRepository mockTestRepository;

  const testStudentId = '3a376f1e-7968-4b8f-94b8-08defc1ba40d';

  setUp(() {
    mockResultRepository = MockResultRepository();
    mockTestRepository = MockTestRepository();
    getLastResultsUseCase = GetLastResultsUseCase(
      mockResultRepository,
      mockTestRepository,
    );
  });

  group('GetLastResultsUseCase', () {
    final List<Result> testResults = [
      InfoObjectMother.createResult(),
      InfoObjectMother.createResult1()
    ];

    final List<Test> testTests = [
      InfoObjectMother.createTest(),
      InfoObjectMother.createTest()
    ];

    test('should return results with test names when data exists', () async {
      when(mockResultRepository.getResultsByStudentId(testStudentId))
          .thenAnswer((_) async => testResults);
      when(mockTestRepository.getTestsByIds(any))
          .thenAnswer((_) async => testTests);

      final results = await getLastResultsUseCase.execute(testStudentId);

      verify(mockResultRepository.getResultsByStudentId(testStudentId));
      verify(mockTestRepository.getTestsByIds(any));

      expect(results.length, 2);
      expect(results[0].score, testResults[0].score);
      expect(results[0].testName, testTests[0].title);
      expect(results[1].score, testResults[1].score);
      expect(results[1].testName, testTests[1].title);
    });

    test('should return empty list when no results exist', () async {
      when(mockResultRepository.getResultsByStudentId(testStudentId))
          .thenAnswer((_) async => []);

      final results = await getLastResultsUseCase.execute(testStudentId);

      verify(mockResultRepository.getResultsByStudentId(testStudentId));
      verifyZeroInteractions(mockTestRepository);

      expect(results, isEmpty);
    });

    test('should rethrow exceptions from result repository', () async {
      when(mockResultRepository.getResultsByStudentId(testStudentId))
          .thenThrow(Exception('Database error'));

      expect(
        () async => await getLastResultsUseCase.execute(testStudentId),
        throwsA(isA<Exception>()),
      );
    });

    test('should rethrow exceptions from test repository', () async {
      when(mockResultRepository.getResultsByStudentId(testStudentId))
          .thenAnswer((_) async => testResults);
      when(mockTestRepository.getTestsByIds(any))
          .thenThrow(Exception('Test fetch error'));

      expect(
        () async => await getLastResultsUseCase.execute(testStudentId),
        throwsA(isA<Exception>()),
      );
    });
  });
}
