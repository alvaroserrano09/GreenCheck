import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/get_student_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'get_student_use_case_test.mocks.dart' show MockStudentRepository;

@GenerateMocks([StudentRepository])
void main() {
  late GetStudentUseCase getStudentUseCase;
  late MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    getStudentUseCase = GetStudentUseCase(mockStudentRepository);
  });

  group('execute()', () {
    const testEmail = 'test@example.com';
    final testUser = InfoObjectMother.createUserStudent();

    test('should return user when repository finds student', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenAnswer((_) async => testUser);

      final result = await getStudentUseCase.execute(testEmail);

      verify(mockStudentRepository.getStudentByEmail(testEmail));
      expect(result, equals(testUser));
    });

    test('should return null when student not found', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenAnswer((_) async => null);

      final result = await getStudentUseCase.execute(testEmail);

      verify(mockStudentRepository.getStudentByEmail(testEmail));
      expect(result, isNull);
    });

    test('should propagate repository exceptions', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenThrow(Exception('Database error'));

      expect(
        () async => await getStudentUseCase.execute(testEmail),
        throwsA(isA<Exception>()),
      );
    });

    test('should call repository with correct email', () async {
      when(mockStudentRepository.getStudentByEmail(testEmail))
          .thenAnswer((_) async => testUser);

      await getStudentUseCase.execute(testEmail);

      verify(mockStudentRepository.getStudentByEmail(testEmail));
    });

    test('should handle empty email', () async {
      when(mockStudentRepository.getStudentByEmail(''))
          .thenAnswer((_) async => null);

      final result = await getStudentUseCase.execute('');

      expect(result, isNull);
    });
  });
}
