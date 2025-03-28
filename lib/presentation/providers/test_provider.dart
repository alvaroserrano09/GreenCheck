import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/domain/usecases/get_tests_use_case.dart';
import 'package:green_check/infrastructure/repositories/test_repository.dart';
import 'package:green_check/infrastructure/services/test_service.dart';

final testRepositoryProvider = Provider<TestRepository>((ref) {
  return TestRepository(TestService());
});

final getTestsUseCaseProvider = Provider<GetTestsUseCase>((ref) {
  final testRepository = ref.watch(testRepositoryProvider);
  return GetTestsUseCase(testRepository);
});

class TestState {
  final bool isLoading;
  final String? errorMessage;
  final Test? test;
  final List<Test> tests;

  TestState({
    required this.isLoading,
    this.errorMessage,
    this.test,
    this.tests = const [],
  });

  TestState copyWith({
    bool? isLoading,
    String? errorMessage,
    Test? test,
    List<Test>? tests,
  }) {
    return TestState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      test: test ?? this.test,
      tests: tests ?? this.tests,
    );
  }

  factory TestState.initial() => TestState(isLoading: false);
}

class TestNotifier extends StateNotifier<TestState> {
  GetTestsUseCase getTestsUseCase;
  TestNotifier(this.getTestsUseCase) : super(TestState.initial());

  Future<void> getTests({
    required int idCourse,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await getTestsUseCase.execute(idCourse);
      if (mounted) {
        state = state.copyWith(isLoading: false, tests: response);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }
}

final testProvider = StateNotifierProvider<TestNotifier, TestState>(
  (ref) => TestNotifier(
    ref.watch(getTestsUseCaseProvider),
  ),
);
