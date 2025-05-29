import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/toggle_favorite_course_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'toggle_favorite_course_use_case_test.mocks.dart';

@GenerateMocks([StudentCourseRepository])
void main() {
  late ToggleFavoriteCourseUseCase toggleFavoriteCourseUseCase;
  late MockStudentCourseRepository mockStudentCourseRepository;

  setUp(() {
    mockStudentCourseRepository = MockStudentCourseRepository();
    toggleFavoriteCourseUseCase =
        ToggleFavoriteCourseUseCase(mockStudentCourseRepository);
  });

  group('execute()', () {
    const testCourseId = 'asadcasdasd-asdasd-asdasd';
    const testStudentId = 'asascasdasdasd-asdasd-asdasd';

    test('should toggle favorite status to true', () async {
      when(mockStudentCourseRepository.toggleFavorite(
              testCourseId, true, testStudentId))
          .thenAnswer((_) async => Future.value());

      await toggleFavoriteCourseUseCase.execute(
          testCourseId, true, testStudentId);

      verify(mockStudentCourseRepository.toggleFavorite(
          testCourseId, true, testStudentId));
      verifyNoMoreInteractions(mockStudentCourseRepository);
    });

    test('should toggle favorite status to false', () async {
      when(mockStudentCourseRepository.toggleFavorite(
              testCourseId, false, testStudentId))
          .thenAnswer((_) async => Future.value());

      await toggleFavoriteCourseUseCase.execute(
          testCourseId, false, testStudentId);

      verify(mockStudentCourseRepository.toggleFavorite(
          testCourseId, false, testStudentId));
    });

    test('should verify repository is called exactly once', () async {
      when(mockStudentCourseRepository.toggleFavorite(
              testCourseId, true, testStudentId))
          .thenAnswer((_) async => Future.value());

      await toggleFavoriteCourseUseCase.execute(
          testCourseId, true, testStudentId);

      verify(mockStudentCourseRepository.toggleFavorite(
              testCourseId, true, testStudentId))
          .called(1);
    });
    test('should not throw when operation completes successfully', () async {
      when(mockStudentCourseRepository.toggleFavorite(
              testCourseId, true, testStudentId))
          .thenAnswer((_) async => Future.value());

      expect(
        () async => await toggleFavoriteCourseUseCase.execute(
            testCourseId, true, testStudentId),
        returnsNormally,
      );
    });
  });
}
