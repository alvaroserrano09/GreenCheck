import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/delete_course_use_case.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_course_use_case_test.mocks.dart';

@GenerateMocks([CourseRepository])
void main() {
  late DeleteCourseUseCase deleteCourseUseCase;
  late MockCourseRepository mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepository();
    deleteCourseUseCase = DeleteCourseUseCase(mockCourseRepository);
  });

  group('deleteCourseUseCase', () {
    const testCourseId = '0e7b8d65-37a1-4c2a-babb-35d5db592e8d';

    test('should call deleteCourse on repository with correct parameters',
        () async {
      when(mockCourseRepository.deleteCourse(testCourseId))
          .thenAnswer((_) async => Future.value());

      await deleteCourseUseCase.execute(testCourseId);

      verify(mockCourseRepository.deleteCourse(testCourseId));
      expect(deleteCourseUseCase.execute(testCourseId), completes);
    });

    test('should propagate exceptions from repository', () async {
      when(mockCourseRepository.deleteCourse(testCourseId))
          .thenThrow(Exception('Database error'));

      expect(() async => await deleteCourseUseCase.execute(testCourseId),
          throwsA(isA<Exception>()));
    });
  });
}
