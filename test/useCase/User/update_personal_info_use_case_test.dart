import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/domain/usecases/update_personal_info_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'update_personal_info_use_case_test.mocks.dart';

@GenerateMocks([StudentRepository, TeacherRepository])
void main() {
  late UpdatePersonalInfoUseCase updatePersonalInfoUseCase;
  late MockStudentRepository mockStudentRepository;
  late MockTeacherRepository mockTeacherRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    mockTeacherRepository = MockTeacherRepository();
    updatePersonalInfoUseCase = UpdatePersonalInfoUseCase(
      mockStudentRepository,
      mockTeacherRepository,
    );
  });

  group('execute()', () {
    const testEmail = 'test@example.com';
    const testName = 'John';
    const testSurname = 'Doe';
    final updatedStudent = InfoObjectMother.createUserTeacher();
    final updatedTeacher = User(
      id: 'teacher456',
      name: testName,
      surname: testSurname,
      email: testEmail,
      role: 'profesor',
    );

    test('should update teacher info when role is profesor', () async {
      when(mockTeacherRepository.updatePersonalInfoTeacher(
        testEmail,
        testName,
        testSurname,
      )).thenAnswer((_) async => updatedTeacher);

      final result = await updatePersonalInfoUseCase.execute(
        testEmail,
        testName,
        testSurname,
        'profesor',
      );

      verify(mockTeacherRepository.updatePersonalInfoTeacher(
        testEmail,
        testName,
        testSurname,
      ));
      verifyZeroInteractions(mockStudentRepository);
      expect(result, equals(updatedTeacher));
    });

    test('should update student info when role is alumno', () async {
      when(mockStudentRepository.updatePersonalInfoStudent(
        testEmail,
        testName,
        testSurname,
      )).thenAnswer((_) async => updatedStudent);

      final result = await updatePersonalInfoUseCase.execute(
        testEmail,
        testName,
        testSurname,
        'alumno',
      );

      verify(mockStudentRepository.updatePersonalInfoStudent(
        testEmail,
        testName,
        testSurname,
      ));
      verifyZeroInteractions(mockTeacherRepository);
      expect(result, equals(updatedStudent));
    });

    test('should throw exception for invalid role', () async {
      expect(
        () async => await updatePersonalInfoUseCase.execute(
          testEmail,
          testName,
          testSurname,
          'invalid_role',
        ),
        throwsA(isA<Exception>()),
      );
      verifyZeroInteractions(mockStudentRepository);
      verifyZeroInteractions(mockTeacherRepository);
    });

    test('should propagate teacher repository exceptions', () async {
      when(mockTeacherRepository.updatePersonalInfoTeacher(
        testEmail,
        testName,
        testSurname,
      )).thenThrow(Exception('Teacher update failed'));

      expect(
        () async => await updatePersonalInfoUseCase.execute(
          testEmail,
          testName,
          testSurname,
          'profesor',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate student repository exceptions', () async {
      when(mockStudentRepository.updatePersonalInfoStudent(
        testEmail,
        testName,
        testSurname,
      )).thenThrow(Exception('Student update failed'));

      expect(
        () async => await updatePersonalInfoUseCase.execute(
          testEmail,
          testName,
          testSurname,
          'alumno',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should verify only one repository is called per role', () async {
      when(mockStudentRepository.updatePersonalInfoStudent(
        testEmail,
        testName,
        testSurname,
      )).thenAnswer((_) async => updatedStudent);

      await updatePersonalInfoUseCase.execute(
        testEmail,
        testName,
        testSurname,
        'alumno',
      );

      verifyNever(mockTeacherRepository.updatePersonalInfoTeacher(
        any,
        any,
        any,
      ));
    });
  });
}
