import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/answer.dart';
import 'package:green_check/domain/usecases/get_questions_test_use_case.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'get_questions_test_use_case_test.mocks.dart' show MockTestRepository;

@GenerateMocks([TestRepository])
void main() {
  late GetQuestionsTestUseCase getQuestionsTestUseCase;
  late MockTestRepository mockTestRepository;

  setUp(() {
    mockTestRepository = MockTestRepository();
    getQuestionsTestUseCase = GetQuestionsTestUseCase(mockTestRepository);
  });

  group('execute()', () {
    const testId = '54799959-57f5-4b96-bd6b-a34a380c1561';
    final List<Question> testQuestions = [
      InfoObjectMother.createQuestion(),
      InfoObjectMother.createQuestion1()
    ];

    test('should return questions with answers from repository', () async {
      when(mockTestRepository.getQuestions(testId))
          .thenAnswer((_) async => testQuestions);

      final result = await getQuestionsTestUseCase.execute(testId);

      verify(mockTestRepository.getQuestions(testId));
      expect(result, testQuestions);
      expect(result.first.answers[0].isCorrect, isTrue);
    });

    test('should maintain correct answer structure', () async {
      when(mockTestRepository.getQuestions(testId))
          .thenAnswer((_) async => testQuestions);

      final result = await getQuestionsTestUseCase.execute(testId);

      expect(result.first.answers, isA<List<Answer>>());
      expect(result.first.answers[0], isA<Answer>());
      expect(result.first.answers[0].text, 'Consejo de Gobierno');
    });

    test('should handle questions with no correct answers', () async {
      final invalidQuestion = InfoObjectMother.createQuestionInvalid();

      when(mockTestRepository.getQuestions(testId))
          .thenAnswer((_) async => [invalidQuestion]);

      final result = await getQuestionsTestUseCase.execute(testId);

      expect(result.single.answers.any((a) => a.isCorrect), isFalse);
    });

    test('should handle empty answers list', () async {
      final emptyAnswersQuestion =
          InfoObjectMother.createQuestionEmptyAnswers();
      when(mockTestRepository.getQuestions(testId))
          .thenAnswer((_) async => [emptyAnswersQuestion]);

      final result = await getQuestionsTestUseCase.execute(testId);

      expect(result.single.answers, isEmpty);
    });

    test('should verify answer JSON serialization', () async {
      final answer = Answer(text: 'Test', isCorrect: true);
      final json = answer.toJson();
      final fromJson = Answer.fromJson(json);

      expect(json, {'texto': 'Test', 'correcta': true});
      expect(fromJson.text, 'Test');
      expect(fromJson.isCorrect, isTrue);
    });
  });
}
