import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/delete_student_course_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_student_use_case_test.mocks.dart';

@GenerateMocks([StudentCourseRepository])
void main() {
  late DeleteStudentCourseUseCase deleteStudentCourseUseCase;
  late MockStudentCourseRepository mockStudentCourseRepository;

  setUp(() {
    mockStudentCourseRepository = MockStudentCourseRepository();
    deleteStudentCourseUseCase =
        DeleteStudentCourseUseCase(mockStudentCourseRepository);
  });

  group('DeleteStudentCourseUseCase', () {
    const testStudentId = '3a376f1e-7968-4b8f-94b8-08defc1ba40d';
    const testCourseId = '0e7b8d65-37a1-4c2a-babb-35d5db592e8d';

    test('should call deleteStudent on repository with correct parameters',
        () async {
      when(mockStudentCourseRepository.deleteStudent(
              testStudentId, testCourseId))
          .thenAnswer((_) async => Future.value());

      await deleteStudentCourseUseCase.execute(testStudentId, testCourseId);

      verify(mockStudentCourseRepository.deleteStudent(
          testStudentId, testCourseId));
      expect(deleteStudentCourseUseCase.execute(testStudentId, testCourseId),
          completes);
    });
    test('should propagate exceptions from repository', () async {
      when(mockStudentCourseRepository.deleteStudent(
              testStudentId, testCourseId))
          .thenThrow(Exception('Database error'));

      expect(
          () async => await deleteStudentCourseUseCase.execute(
              testStudentId, testCourseId),
          throwsA(isA<Exception>()));
    });
  });
}
