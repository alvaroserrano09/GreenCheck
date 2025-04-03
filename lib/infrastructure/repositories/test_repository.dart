import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/services/test_service.dart';

class TestRepository {
  final TestService datasource;

  TestRepository(this.datasource);

  Future<List<Test>> getTests(int idCourse) {
    return datasource.getTests(idCourse);
  }

  Future createTest<Test>(String title, int idCourse) {
    return datasource.saveTest(title, idCourse);
  }

  saveQuestions(List<Question> questionsToSave, id) {
    return datasource.saveQuestions(questionsToSave, id);
  }

  void deleteTest(int idTest, int idCourse) {
    return datasource.deleteTest(idTest, idCourse);
  }

  Future<List<Question>> getQuestions(int testId) {
    return datasource.getQuestions(testId);
  }
}
