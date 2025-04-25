import 'package:green_check/domain/models/result.dart';
import 'package:green_check/infrastructure/services/result_service.dart';

class ResultRepository {
  final ResultService datasource;
  ResultRepository(this.datasource);
  Future<Result> saveResult(Result result) async {
    return datasource.saveResult(result);
  }

  Future<List<Result>> getResultsByStudentId(int studentId) {
    final aar = datasource.getResultsByStudentId(studentId);
    print(aar);
    return aar;
  }
}
