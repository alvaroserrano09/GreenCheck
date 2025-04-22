import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/result.dart';
import 'package:green_check/domain/usecases/save_result_use_case.dart';
import 'package:green_check/infrastructure/repositories/result_repository.dart';
import 'package:green_check/infrastructure/services/result_service.dart';

final resultRepositoryPrivder = Provider<ResultRepository>((ref) {
  return ResultRepository(ResultService());
});

final saveResultUseCaseProvider = Provider<SaveResultUseCase>((ref) {
  final resultRepository = ref.watch(resultRepositoryPrivder);
  return SaveResultUseCase(resultRepository);
});

class ResultState {
  final bool isLoading;
  final String? errorMessage;
  final Result? result;

  ResultState({
    required this.isLoading,
    this.errorMessage,
    this.result,
  });

  ResultState copyWith({
    bool? isLoading,
    String? errorMessage,
    Result? result,
  }) {
    return ResultState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      result: result ?? this.result,
    );
  }

  factory ResultState.initial() => ResultState(isLoading: false);
}

class ResultNotifier extends StateNotifier<ResultState> {
  final SaveResultUseCase saveResultUseCase;

  ResultNotifier(this.saveResultUseCase) : super(ResultState.initial());

  Future<void> saveResult(Result result) async {
    state = state.copyWith(isLoading: true);
    try {
      final newResult = await saveResultUseCase.saveResult(result);
      state = state.copyWith(result: newResult, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to save result: $e', isLoading: false);
    }
  }
}

final resultProvider = StateNotifierProvider<ResultNotifier, ResultState>(
  (ref) => ResultNotifier(
    ref.watch(saveResultUseCaseProvider),
  ),
);
