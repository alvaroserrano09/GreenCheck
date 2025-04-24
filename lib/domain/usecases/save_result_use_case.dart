import 'package:green_check/domain/models/result.dart';
import 'package:green_check/infrastructure/repositories/result_repository.dart';

class SaveResultUseCase {
  final ResultRepository resultRepository;
  SaveResultUseCase(this.resultRepository);

  Future<Result> saveResult(Result result) async {
    try {
      final newResult = await resultRepository.saveResult(result);
      return newResult;
    } catch (e) {
      throw Exception('Failed to save result: $e');
    }
  }
}
