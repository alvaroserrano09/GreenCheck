import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/save_student_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../mother/info_object_mother.dart';
import 'save_student_use_case_test.mocks.dart';

@GenerateMocks([StudentRepository])
void main() {
  late SaveStudentUseCase saveStudentUseCase;
  late MockStudentRepository mockStudentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
    saveStudentUseCase = SaveStudentUseCase(mockStudentRepository);
  });

  group('SaveStudentUseCase', () {
    final testUser = InfoObjectMother.createUserStudent();
    const testPassword = 'testPassword123';
    const testRole = 'student';

    test('should call saveStudent on repository with correct parameters',
        () async {
      when(mockStudentRepository.saveStudent(testUser, testPassword, testRole))
          .thenAnswer((_) async => testUser);

      await saveStudentUseCase.execute(testUser, testPassword, testRole);

      verify(
          mockStudentRepository.saveStudent(testUser, testPassword, testRole));
      verifyNoMoreInteractions(mockStudentRepository);
    });

    test('should return the saved student from repository', () async {
      when(mockStudentRepository.saveStudent(testUser, testPassword, testRole))
          .thenAnswer((_) async => testUser);

      final result =
          await saveStudentUseCase.execute(testUser, testPassword, testRole);
      expect(result, equals(testUser));
    });

    test('should propagate exceptions from repository', () async {
      when(mockStudentRepository.saveStudent(testUser, testPassword, testRole))
          .thenThrow(Exception('Database error'));
      expect(
          () async => await saveStudentUseCase.execute(
              testUser, testPassword, testRole),
          throwsA(isA<Exception>()));
    });
  });
}
