import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';

class GetTestsUseCase {
  final TestRepository testRepository;
  GetTestsUseCase(this.testRepository);

  Future<List<Test>> execute(String idCourse) async {
    return await testRepository.getTests(idCourse);
  }
}
