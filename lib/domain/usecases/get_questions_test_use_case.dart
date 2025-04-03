import 'package:green_check/domain/models/question.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';

class GetQuestionsTestUseCase {
  TestRepository testRepository;

  GetQuestionsTestUseCase(this.testRepository);

  Future<List<Question>> execute(int testId) async {
    final questions = await testRepository.getQuestions(testId);
    return questions;
  }
}
