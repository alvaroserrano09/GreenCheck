import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/result.dart';
import 'package:green_check/domain/usecases/get_last_results_use_case.dart';
import 'package:green_check/domain/usecases/save_result_use_case.dart';
import 'package:green_check/infrastructure/repositories/result_repository.dart';
import 'package:green_check/infrastructure/services/result_service.dart';
import 'package:green_check/presentation/providers/test_provider.dart';

final resultRepositoryProvider = Provider<ResultRepository>((ref) {
  return ResultRepository(ResultService());
});

final saveResultUseCaseProvider = Provider<SaveResultUseCase>((ref) {
  final resultRepository = ref.read(resultRepositoryProvider);
  return SaveResultUseCase(resultRepository);
});

final getLastResultsUseCaseProvider = Provider<GetLastResultsUseCase>((ref) {
  final resultRepository = ref.read(resultRepositoryProvider);
  final testRepository = ref.read(testRepositoryProvider);
  return GetLastResultsUseCase(resultRepository, testRepository);
});

class ResultState {
  final bool isLoading;
  final String? errorMessage;
  final List<Result>? results;

  ResultState({
    required this.isLoading,
    this.errorMessage,
    this.results,
  });

  ResultState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Result>? results,
  }) {
    return ResultState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      results: results ?? this.results,
    );
  }

  factory ResultState.initial() => ResultState(isLoading: false);
}

class ResultNotifier extends StateNotifier<ResultState> {
  final SaveResultUseCase saveResultUseCase;
  final GetLastResultsUseCase getLastResultsUseCase;

  ResultNotifier(
    this.saveResultUseCase,
    this.getLastResultsUseCase,
  ) : super(ResultState.initial());

  Future<void> saveResult(Result result) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await saveResultUseCase.saveResult(result);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to save result: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> getLastResults(int studentId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await getLastResultsUseCase.execute(studentId);
      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to get last results: ${e.toString()}',
        isLoading: false,
      );
    }
  }
}

final resultProvider = StateNotifierProvider<ResultNotifier, ResultState>(
  (ref) => ResultNotifier(
    ref.read(saveResultUseCaseProvider),
    ref.read(getLastResultsUseCaseProvider),
  ),
);
