import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/services/test_service.dart';

class TestRepository {
  final TestService datasource;

  TestRepository(this.datasource);

  Future<List<Test>> getTests(String idCourse) {
    return datasource.getTests(idCourse);
  }

  Future createTest<Test>(String title, String idCourse) {
    return datasource.saveTest(title, idCourse);
  }

  saveQuestions(List<Question> questionsToSave, id) {
    return datasource.saveQuestions(questionsToSave, id);
  }

  void deleteTest(int idTest, String idCourse) {
    return datasource.deleteTest(idTest, idCourse);
  }

  Future<List<Question>> getQuestions(int testId) {
    return datasource.getQuestions(testId);
  }

  Future<List<Test>> getTestsByIds(testIds) {
    return datasource.getTestsByIds(testIds);
  }
}
