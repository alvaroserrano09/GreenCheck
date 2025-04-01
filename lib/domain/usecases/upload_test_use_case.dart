import 'package:file_picker/file_picker.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:green_check/infrastructure/services/file_reader_service.dart';
import 'package:green_check/infrastructure/services/test_parser_service.dart';

class UploadTestUseCase {
  final TestRepository _repository;
  final FileReader _fileReader;
  final TestParser _testParser;

  UploadTestUseCase(this._repository, this._fileReader, this._testParser);

  Future<Test> execute({
    required int courseId,
    required String title,
    required PlatformFile file,
    required void Function(double progress) onProgress,
  }) async {
    try {
      final content = await _fileReader.readFile(file);
      final questions = _testParser.parse(content);

      final createdTest = await _repository.createTest(title, courseId);
      await _repository.saveQuestions(questions, createdTest.id);

      onProgress(1.0);
      return createdTest;
    } catch (e) {
      onProgress(0.0);
      rethrow;
    }
  }
}
