import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/save_student_course.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../mother/info_object_mother.dart';
import 'save_student_course_use_case_test.mocks.dart';

@GenerateMocks([StudentCourseRepository, StudentRepository])
void main() {
  late SaveStudentCourseUseCase saveStudentCourseUseCase;
  late MockStudentCourseRepository mockStudentCourseRepository;
  late MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentCourseRepository = MockStudentCourseRepository();
    mockStudentRepository = MockStudentRepository();
    saveStudentCourseUseCase = SaveStudentCourseUseCase(
      mockStudentCourseRepository,
      mockStudentRepository,
    );
  });

  group('execute()', () {
    const testEmail = 'student@example.com';
    const testCourseId = 'asd-asasd-asdasd-asdasd';
    final testStudent = InfoObjectMother.createUserStudent();
    final updatedStudent = InfoObjectMother.createUserStudent();

    test('should save student course and return updated student', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenAnswer((_) async => testStudent);
      when(mockStudentCourseRepository.saveStudent(
              testCourseId, testStudent.id))
          .thenAnswer((_) async => updatedStudent);

      final result =
          await saveStudentCourseUseCase.execute(testCourseId, testEmail);

      verify(mockStudentRepository.getStudentByEmail(testEmail));
      verify(mockStudentCourseRepository.saveStudent(
          testCourseId, testStudent.id));
      expect(result, equals(updatedStudent));
    });
    test('should propagate student repository exceptions', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenThrow(Exception('Student lookup failed'));

      expect(
        () async =>
            await saveStudentCourseUseCase.execute(testCourseId, testEmail),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate student course repository exceptions', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenAnswer((_) async => testStudent);
      when(mockStudentCourseRepository.saveStudent(
              testCourseId, testStudent.id))
          .thenThrow(Exception('Save failed'));

      expect(
        () async =>
            await saveStudentCourseUseCase.execute(testCourseId, testEmail),
        throwsA(isA<Exception>()),
      );
    });

    test('should verify correct parameters are passed', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenAnswer((_) async => testStudent);
      when(mockStudentCourseRepository.saveStudent(
              testCourseId, testStudent.id))
          .thenAnswer((_) async => updatedStudent);

      await saveStudentCourseUseCase.execute(testCourseId, testEmail);

      verify(mockStudentRepository.getStudentByEmail(testEmail));
      verify(mockStudentCourseRepository.saveStudent(
          testCourseId, testStudent.id));
    });
  });
}
