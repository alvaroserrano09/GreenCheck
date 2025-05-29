import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/delete_test_use_case.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_test_use__case_test.mocks.dart';

@GenerateMocks([TestRepository])
void main() {
  late DeleteTestUseCase deleteTestUseCase;
  late MockTestRepository mockTestRepository;

  setUp(() {
    mockTestRepository = MockTestRepository();
    deleteTestUseCase = DeleteTestUseCase(mockTestRepository);
  });

  group('deleteTestUseCase', () {
    const testId = '54799959-57f5-4b96-bd6b-a34a380c1561';
    const testCourseId = '0e7b8d65-37a1-4c2a-babb-35d5db592e8d';

    test('should call deleteTest on repository with correct parameters',
        () async {
      when(mockTestRepository.deleteTest(testId, testCourseId))
          .thenAnswer((_) async => Future.value());

      await deleteTestUseCase.execute(testId, testCourseId);

      verify(mockTestRepository.deleteTest(testId, testCourseId));
      expect(deleteTestUseCase.execute(testId, testCourseId), completes);
    });
    test('should propagate exceptions from repository', () async {
      when(mockTestRepository.deleteTest(testId, testCourseId))
          .thenThrow(Exception('Database error'));

      expect(() async => await deleteTestUseCase.execute(testId, testCourseId),
          throwsA(isA<Exception>()));
    });
  });
}
