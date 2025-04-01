import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/domain/usecases/delete_test_use_case.dart';
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

class TestState {
  final bool isLoading;
  final bool isUploading;
  final String? errorMessage;
  final Test? currentTest;
  final List<Test> tests;
  final double? uploadProgress;

  const TestState({
    this.isLoading = false,
    this.isUploading = false,
    this.errorMessage,
    this.currentTest,
    this.tests = const [],
    this.uploadProgress,
  });

  TestState copyWith({
    bool? isLoading,
    bool? isUploading,
    String? errorMessage,
    Test? currentTest,
    List<Test>? tests,
    double? uploadProgress,
  }) {
    return TestState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentTest: currentTest ?? this.currentTest,
      tests: tests ?? this.tests,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}

class TestNotifier extends StateNotifier<TestState> {
  final GetTestsUseCase _getTestsUseCase;
  final UploadTestUseCase _uploadTestUseCase;
  final DeleteTestUseCase _deleteTestUseCase;

  TestNotifier({
    required GetTestsUseCase getTestsUseCase,
    required UploadTestUseCase uploadTestUseCase,
    required DeleteTestUseCase deleteTestUseCase,
  })  : _getTestsUseCase = getTestsUseCase,
        _uploadTestUseCase = uploadTestUseCase,
        _deleteTestUseCase = deleteTestUseCase,
        super(const TestState());

  Future<void> getTests({required int idCourse}) async {
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
    required int courseId,
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
    required int courseId,
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
}

final testProvider = StateNotifierProvider<TestNotifier, TestState>((ref) {
  return TestNotifier(
    getTestsUseCase: ref.watch(getTestsUseCaseProvider),
    uploadTestUseCase: ref.watch(uploadTestUseCaseProvider),
    deleteTestUseCase: ref.watch(deleteTestUseCaseProvider),
  );
});
