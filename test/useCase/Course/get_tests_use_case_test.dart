import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/domain/usecases/get_tests_use_case.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'get_tests_use_case_test.mocks.dart' show MockTestRepository;

@GenerateMocks([TestRepository])
void main() {
  late GetTestsUseCase getTestsUseCase;
  late MockTestRepository mockTestRepository;

  setUp(() {
    mockTestRepository = MockTestRepository();
    getTestsUseCase = GetTestsUseCase(mockTestRepository);
  });

  group('execute()', () {
    const courseId = 'adsas-1234-5678-90ab-cdef12345678';
    final List<Test> testList = [
      InfoObjectMother.createTest(),
      InfoObjectMother.createTest1()
    ];

    test('should return tests for given course ID', () async {
      when(mockTestRepository.getTests(courseId))
          .thenAnswer((_) async => testList);

      final result = await getTestsUseCase.execute(courseId);

      verify(mockTestRepository.getTests(courseId));
      expect(result, equals(testList));
      expect(result.length, 2);
    });

    test('should return empty list when no tests exist', () async {
      when(mockTestRepository.getTests(courseId)).thenAnswer((_) async => []);

      final result = await getTestsUseCase.execute(courseId);

      verify(mockTestRepository.getTests(courseId));
      expect(result, isEmpty);
    });

    test('should propagate repository exceptions', () async {
      when(mockTestRepository.getTests(courseId))
          .thenThrow(Exception('Database error'));

      expect(
        () async => await getTestsUseCase.execute(courseId),
        throwsA(isA<Exception>()),
      );
    });

    test('should verify repository is called exactly once', () async {
      when(mockTestRepository.getTests(courseId))
          .thenAnswer((_) async => testList);

      await getTestsUseCase.execute(courseId);

      verify(mockTestRepository.getTests(courseId)).called(1);
    });

    test('should handle empty course ID', () async {
      when(mockTestRepository.getTests('')).thenAnswer((_) async => []);

      final result = await getTestsUseCase.execute('');

      expect(result, isEmpty);
    });
  });
}
