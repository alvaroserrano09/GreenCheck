import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/domain/usecases/delete_test_use_case.dart';
import 'package:green_check/domain/usecases/get_questions_test_use_case.dart';
import 'package:green_check/domain/usecases/get_tests_use_case.dart';
import 'package:green_check/domain/usecases/upload_test_use_case.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:green_check/infrastructure/services/file_reader_service.dart';
import 'package:green_check/infrastructure/services/test_parser_service.dart';
import 'package:green_check/infrastructure/services/test_service.dart';

final testRepositoryProvider = Provider<TestRepository>((ref) {
  return TestRepository(TestService());
});
final fileReaderProvider = Provider<FileReader>((ref) {
  return FileReader();
});

final testParserProvider = Provider<TestParser>((ref) {
  return TestParser();
});

final getTestsUseCaseProvider = Provider<GetTestsUseCase>((ref) {
  return GetTestsUseCase(ref.watch(testRepositoryProvider));
});

final uploadTestUseCaseProvider = Provider<UploadTestUseCase>((ref) {
  return UploadTestUseCase(
    ref.watch(testRepositoryProvider),
    ref.watch(fileReaderProvider),
    ref.watch(testParserProvider),
  );
});

final deleteTestUseCaseProvider = Provider<DeleteTestUseCase>((ref) {
  return DeleteTestUseCase(ref.watch(testRepositoryProvider));
});
final getQuestionsTestUseCaseProvider =
    Provider<GetQuestionsTestUseCase>((ref) {
  return GetQuestionsTestUseCase(ref.watch(testRepositoryProvider));
});

class TestState {
  final bool isLoading;
  final bool isUploading;
  final String? errorMessage;
  final Test? currentTest;
  final List<Test> tests;
  final List<Question> questions;
  final double? uploadProgress;

  const TestState({
    this.isLoading = false,
    this.isUploading = false,
    this.errorMessage,
    this.currentTest,
    this.tests = const [],
    this.questions = const [],
    this.uploadProgress,
  });

  TestState copyWith({
    bool? isLoading,
    bool? isUploading,
    String? errorMessage,
    Test? currentTest,
    List<Test>? tests,
    List<Question>? questions,
    double? uploadProgress,
  }) {
    return TestState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentTest: currentTest ?? this.currentTest,
      tests: tests ?? this.tests,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      questions: this.questions,
    );
  }
}

class TestNotifier extends StateNotifier<TestState> {
  final GetTestsUseCase _getTestsUseCase;
  final UploadTestUseCase _uploadTestUseCase;
  final DeleteTestUseCase _deleteTestUseCase;
  final GetQuestionsTestUseCase _getQuestionsTestUseCase;

  TestNotifier({
    required GetTestsUseCase getTestsUseCase,
    required UploadTestUseCase uploadTestUseCase,
    required DeleteTestUseCase deleteTestUseCase,
    required GetQuestionsTestUseCase getQuestionsTestUseCase,
  })  : _getTestsUseCase = getTestsUseCase,
        _uploadTestUseCase = uploadTestUseCase,
        _deleteTestUseCase = deleteTestUseCase,
        _getQuestionsTestUseCase = getQuestionsTestUseCase,
        super(const TestState());

  Future<void> getTests({required String idCourse}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final tests = await _getTestsUseCase.execute(idCourse);
      state = state.copyWith(
        isLoading: false,
        tests: tests,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar tests: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<void> uploadTest({
    required String courseId,
    required String title,
    required PlatformFile file,
  }) async {
    state = state.copyWith(
      isUploading: true,
      uploadProgress: 0,
      errorMessage: null,
    );

    try {
      if (kIsWeb && file.bytes == null) {
        throw Exception('No se pudieron leer los datos del archivo');
      } else if (!kIsWeb && file.path == null) {
        throw Exception('Ruta de archivo no disponible');
      }

      final Test test = await _uploadTestUseCase.execute(
        courseId: courseId,
        title: title,
        file: file,
        onProgress: (progress) {
          state = state.copyWith(uploadProgress: progress);
        },
      );

      state = state.copyWith(
        isUploading: false,
        tests: [...state.tests, test],
        uploadProgress: null,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'Error al subir test: ${e.toString()}',
        uploadProgress: null,
      );
      rethrow;
    }
  }

  Future<void> deleteTest({
    required String courseId,
    required int testId,
  }) async {
    state = state.copyWith(
      isUploading: true,
      errorMessage: null,
    );
    try {
      await _deleteTestUseCase.execute(testId, courseId);
      if (mounted) {
        final updateTests =
            state.tests.where((test) => test.id != testId).toList();

        state = state.copyWith(
          isLoading: false,
          tests: updateTests,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'Error al subir test: ${e.toString()}',
        uploadProgress: null,
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<List<Question>> getTestQuestions(int testId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, questions: []);

    try {
      final questions = await _getQuestionsTestUseCase.execute(testId);
      state = state.copyWith(
        isLoading: false,
        questions: questions,
        errorMessage: null,
      );
      return questions;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar preguntas del test: ${e.toString()}',
        questions: [],
      );
      rethrow;
    }
  }
}

final testProvider = StateNotifierProvider<TestNotifier, TestState>((ref) {
  return TestNotifier(
    getTestsUseCase: ref.watch(getTestsUseCaseProvider),
    uploadTestUseCase: ref.watch(uploadTestUseCaseProvider),
    deleteTestUseCase: ref.watch(deleteTestUseCaseProvider),
    getQuestionsTestUseCase: ref.watch(getQuestionsTestUseCaseProvider),
  );
});
