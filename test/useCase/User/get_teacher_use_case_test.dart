import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/get_teacher_use_case.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'get_teacher_use_case_test.mocks.dart' show MockTeacherRepository;

@GenerateMocks([TeacherRepository])
void main() {
  late GetTeacherUseCase getTeacherUseCase;
  late MockTeacherRepository mockTeacherRepository;

  setUp(() {
    mockTeacherRepository = MockTeacherRepository();
    getTeacherUseCase = GetTeacherUseCase(mockTeacherRepository);
  });

  group('call()', () {
    const testEmail = 'teacher@example.com';
    final testTeacher = InfoObjectMother.createUserTeacher();

    test('should return teacher when found by email', () async {
      when(mockTeacherRepository.getTeacherByEmail(testEmail))
          .thenAnswer((_) async => testTeacher);

      final result = await getTeacherUseCase(testEmail);

      verify(mockTeacherRepository.getTeacherByEmail(testEmail));
      expect(result, equals(testTeacher));
      expect(result?.role, 'teacher');
    });

    test('should return null when teacher not found', () async {
      when(mockTeacherRepository.getTeacherByEmail(testEmail))
          .thenAnswer((_) async => null);

      final result = await getTeacherUseCase(testEmail);

      verify(mockTeacherRepository.getTeacherByEmail(testEmail));
      expect(result, isNull);
    });

    test('should propagate repository exceptions', () async {
      when(mockTeacherRepository.getTeacherByEmail(testEmail))
          .thenThrow(Exception('Database error'));

      expect(() => getTeacherUseCase(testEmail), throwsException);
    });

    test('should call repository with correct email', () async {
      when(mockTeacherRepository.getTeacherByEmail(testEmail))
          .thenAnswer((_) async => testTeacher);

      await getTeacherUseCase(testEmail);

      verify(mockTeacherRepository.getTeacherByEmail(testEmail)).called(1);
    });
    test('should handle empty email parameter', () async {
      when(mockTeacherRepository.getTeacherByEmail(''))
          .thenAnswer((_) async => null);

      final result = await getTeacherUseCase('');

      expect(result, isNull);
    });

    test('should handle invalid email format', () async {
      const invalidEmail = 'not-an-email';
      when(mockTeacherRepository.getTeacherByEmail(invalidEmail))
          .thenAnswer((_) async => null);

      final result = await getTeacherUseCase(invalidEmail);

      expect(result, isNull);
    });
  });
}
