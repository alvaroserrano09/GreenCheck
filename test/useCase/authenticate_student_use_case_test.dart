import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:green_check/domain/models/student.dart';
import 'package:green_check/domain/usecases/authenticate_student_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

import 'save_student_use_case_test.mocks.dart';

@GenerateMocks([StudentRepository])
void main() {
  late MockStudentRepository mockStudentRepository;
  late AuthenticateStudentUseCase authenticateStudentUseCase;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    authenticateStudentUseCase =
        AuthenticateStudentUseCase(mockStudentRepository);
  });

  group('AuthenticateStudentUseCase', () {
    final student = Student(
      email: 'test@example.com',
      password: 'password123',
      name: 'John',
      surname: 'Doe',
    );

    test('debería autenticar al estudiante correctamente', () async {
      when(mockStudentRepository.authStudent(student.email, student.password))
          .thenAnswer((_) async => student);

      final result = await authenticateStudentUseCase.execute(
          email: student.email, password: student.password);

      expect(result, equals(student));
      verify(mockStudentRepository.authStudent(student.email, student.password))
          .called(1);
    });

    test('debería lanzar una excepción cuando la autenticación falla',
        () async {
      when(mockStudentRepository.authStudent(student.email, student.password))
          .thenThrow(Exception('Error de autenticación'));

      expect(
          () async => await authenticateStudentUseCase.execute(
              email: student.email, password: student.password),
          throwsA(isA<Exception>()));
      verify(mockStudentRepository.authStudent(student.email, student.password))
          .called(1);
    });
  });
}
