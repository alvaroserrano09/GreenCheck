import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/get_teacher_by_id_use_case.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'get_teacher_by_id_use_case_test.mocks.dart' show MockTeacherRepository;

@GenerateMocks([TeacherRepository])
void main() {
  late GetTeacherByIdUseCase getTeacherByIdUseCase;
  late MockTeacherRepository mockTeacherRepository;

  setUp(() {
    mockTeacherRepository = MockTeacherRepository();
    getTeacherByIdUseCase = GetTeacherByIdUseCase(mockTeacherRepository);
  });

  group('execute()', () {
    const testId = 'asasv--asd--asdasd--asdasd';
    final testTeacher = InfoObjectMother.createUserTeacher();

    test('should return teacher when found by repository', () async {
      when(mockTeacherRepository.getTeacherById(testId))
          .thenAnswer((_) async => testTeacher);

      final result = await getTeacherByIdUseCase.execute(testId);

      verify(mockTeacherRepository.getTeacherById(testId));
      expect(result, equals(testTeacher));
    });

    test('should return null when teacher not found', () async {
      when(mockTeacherRepository.getTeacherById(testId))
          .thenAnswer((_) async => null);

      final result = await getTeacherByIdUseCase.execute(testId);

      verify(mockTeacherRepository.getTeacherById(testId));
      expect(result, isNull);
    });

    test('should propagate exceptions from repository', () async {
      when(mockTeacherRepository.getTeacherById(testId))
          .thenThrow(Exception('Database error'));

      expect(
        () async => await getTeacherByIdUseCase.execute(testId),
        throwsA(isA<Exception>()),
      );
    });

    test('should call repository with correct ID exactly once', () async {
      when(mockTeacherRepository.getTeacherById(testId))
          .thenAnswer((_) async => testTeacher);

      await getTeacherByIdUseCase.execute(testId);

      verify(mockTeacherRepository.getTeacherById(testId)).called(1);
    });

    test('should handle empty ID string', () async {
      when(mockTeacherRepository.getTeacherById(''))
          .thenAnswer((_) async => null);

      final result = await getTeacherByIdUseCase.execute('');

      expect(result, isNull);
    });

    test('should return teacher with correct role', () async {
      when(mockTeacherRepository.getTeacherById(testId))
          .thenAnswer((_) async => testTeacher);

      final result = await getTeacherByIdUseCase.execute(testId);

      expect(result?.role, equals('teacher'));
    });
  });
}
