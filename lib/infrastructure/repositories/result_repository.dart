import 'package:green_check/domain/models/result.dart';
import 'package:green_check/infrastructure/services/result_service.dart';

class ResultRepository {
  final ResultService datasource;
  ResultRepository(this.datasource);
  Future<Result> saveResult(Result result) async {
    return datasource.saveResult(result);
  }
}
