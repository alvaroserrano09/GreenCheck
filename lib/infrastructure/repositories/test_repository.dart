import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/services/test_service.dart';

class TestRepository {
  final TestService datasource;

  TestRepository(this.datasource);

  Future<List<Test>> getTests(int idCourse) {
    return datasource.getTests(idCourse);
  }
}
