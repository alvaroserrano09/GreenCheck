import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/save_result_use_case.dart';
import 'package:green_check/infrastructure/repositories/result_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'save_result_use_case_test.mocks.dart';

@GenerateMocks([ResultRepository])
void main() {
  late SaveResultUseCase saveResultUseCase;
  late MockResultRepository mockResultRepository;

  setUp(() {
    mockResultRepository = MockResultRepository();
    saveResultUseCase = SaveResultUseCase(mockResultRepository);
  });

  group('saveResult()', () {
    final testResult = InfoObjectMother.createResult();

    final savedResult = InfoObjectMother.createResult();

    test('should save result and return saved version', () async {
      when(mockResultRepository.saveResult(testResult))
          .thenAnswer((_) async => savedResult);

      final result = await saveResultUseCase.saveResult(testResult);

      verify(mockResultRepository.saveResult(testResult));
      expect(result, equals(savedResult));
    });

    test('should preserve all result properties when saving', () async {
      when(mockResultRepository.saveResult(testResult))
          .thenAnswer((_) async => savedResult);

      final result = await saveResultUseCase.saveResult(testResult);

      expect(result.idTest, equals(testResult.idTest));
      expect(result.idStudent, equals(testResult.idStudent));
      expect(result.score, equals(testResult.score));
    });

    test('should verify repository is called exactly once', () async {
      when(mockResultRepository.saveResult(testResult))
          .thenAnswer((_) async => savedResult);

      await saveResultUseCase.saveResult(testResult);

      verify(mockResultRepository.saveResult(testResult)).called(1);
    });
  });
}
