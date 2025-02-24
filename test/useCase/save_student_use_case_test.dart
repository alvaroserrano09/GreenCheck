import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:green_check/domain/models/user.dart';

import 'save_student_use_case_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  group('UserRepository', () {
    final student = User(
      email: 'test@example.com',
      password: 'password123',
      name: 'John',
      surname: 'Doe',
    );

    test('debería guardar al estudiante correctamente', () async {
      when(mockUserRepository.saveStudent(student))
          .thenAnswer((_) async => student);

      final result = await mockUserRepository.saveStudent(student);

      expect(result, equals(student));
      verify(mockUserRepository.saveStudent(student)).called(1);
    });

    test('debería lanzar una excepción cuando falla', () async {
      when(mockUserRepository.saveStudent(student))
          .thenThrow(Exception('Error al guardar'));

      expect(() async => await mockUserRepository.saveStudent(student),
          throwsA(isA<Exception>()));
      verify(mockUserRepository.saveStudent(student)).called(1);
    });
  });
}
