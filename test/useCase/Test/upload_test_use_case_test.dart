import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/usecases/upload_test_use_case.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:green_check/infrastructure/services/file_reader_service.dart';
import 'package:green_check/infrastructure/services/test_parser_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'upload_test_use_case_test.mocks.dart';

@GenerateMocks([
  TestRepository,
  FileReader,
  TestParser,
])
void main() {
  late UploadTestUseCase uploadTestUseCase;
  late MockTestRepository mockTestRepository;
  late MockFileReader mockFileReader;
  late MockTestParser mockTestParser;

  setUp(() {
    mockTestRepository = MockTestRepository();
    mockFileReader = MockFileReader();
    mockTestParser = MockTestParser();
    uploadTestUseCase = UploadTestUseCase(
      mockTestRepository,
      mockFileReader,
      mockTestParser,
    );
  });

  group('execute()', () {
    const testCourseId = 'course123';
    const testTitle = 'Midterm Exam';
    final testFile = PlatformFile(
      name: 'test.txt',
      size: 100,
      bytes: Uint8List(0),
    );
    final testContent = 'Test content';
    final List<Question> testQuestions = [
      InfoObjectMother.createQuestion(),
      InfoObjectMother.createQuestion1()
    ];
    final createdTest = InfoObjectMother.createTest();

    test('should complete upload process successfully', () async {
      var progressValues = [];
      when(mockFileReader.readFile(testFile))
          .thenAnswer((_) async => testContent);
      when(mockTestParser.parse(testContent)).thenReturn(testQuestions);
      when(mockTestRepository.createTest(testTitle, testCourseId))
          .thenAnswer((_) async => createdTest);
      when(mockTestRepository.saveQuestions(testQuestions, createdTest.id))
          .thenAnswer((_) async => Future.value());

      final result = await uploadTestUseCase.execute(
        courseId: testCourseId,
        title: testTitle,
        file: testFile,
        onProgress: (progress) => progressValues.add(progress),
      );

      verify(mockFileReader.readFile(testFile));
      verify(mockTestParser.parse(testContent));
      verify(mockTestRepository.createTest(testTitle, testCourseId));
      verify(mockTestRepository.saveQuestions(testQuestions, createdTest.id));
      expect(result, equals(createdTest));
      expect(progressValues, equals([1.0]));
    });

    test('should call onProgress with 0.0 when file reading fails', () async {
      var progressValues = [];
      when(mockFileReader.readFile(testFile))
          .thenThrow(Exception('File read error'));

      expect(
        () async => await uploadTestUseCase.execute(
          courseId: testCourseId,
          title: testTitle,
          file: testFile,
          onProgress: (progress) => progressValues.add(progress),
        ),
        throwsException,
      );
      expect(progressValues, equals([0.0]));
    });
  });
}
