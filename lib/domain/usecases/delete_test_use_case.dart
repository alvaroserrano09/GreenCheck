import 'package:green_check/infrastructure/repositories/test_repository.dart';

class DeleteTestUseCase {
  final TestRepository testRepository;
  DeleteTestUseCase(this.testRepository);

  Future<void> execute(String idTest, String idCourse) async {
    testRepository.deleteTest(idTest, idCourse);
  }
}
