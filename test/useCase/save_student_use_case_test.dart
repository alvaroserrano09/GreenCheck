import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:green_check/domain/models/student.dart';

import 'save_student_use_case_test.mocks.dart';

@GenerateMocks([StudentRepository])
void main() {
  late MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
  });

  group('StudentRepository', () {
    final student = Student(
      email: 'test@example.com',
      password: 'password123',
      name: 'John',
      surname: 'Doe',
    );

    test('debería guardar al estudiante correctamente', () async {
      when(mockStudentRepository.saveStudent(student))
          .thenAnswer((_) async => student);

      final result = await mockStudentRepository.saveStudent(student);

      expect(result, equals(student));
      verify(mockStudentRepository.saveStudent(student)).called(1);
    });

    test('debería lanzar una excepción cuando falla', () async {
      when(mockStudentRepository.saveStudent(student))
          .thenThrow(Exception('Error al guardar'));

      expect(() async => await mockStudentRepository.saveStudent(student),
          throwsA(isA<Exception>()));
      verify(mockStudentRepository.saveStudent(student)).called(1);
    });
  });
}
