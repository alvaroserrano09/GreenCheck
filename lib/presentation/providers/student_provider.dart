import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/student.dart';
import 'package:green_check/domain/usecases/save_student_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

// Definición de los Providers
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(StudentService());
});

final saveStudentUseCaseProvider = Provider<SaveStudentUseCase>((ref) {
  final studentRepository = ref.watch(studentRepositoryProvider);
  return SaveStudentUseCase(studentRepository);
});

class StudentState {
  final bool isLoading;
  final String? errorMessage;
  final Student? student;

  StudentState({
    required this.isLoading,
    this.errorMessage,
    this.student,
  });

  StudentState copyWith({
    bool? isLoading,
    String? errorMessage,
    Student? student,
  }) {
    return StudentState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      student: student ?? this.student,
    );
  }

  factory StudentState.initial() => StudentState(isLoading: false);
}

class StudentNotifier extends StateNotifier<StudentState> {
  final SaveStudentUseCase saveStudentUseCase;

  StudentNotifier(this.saveStudentUseCase) : super(StudentState.initial());

  Future<void> registerStudent({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await saveStudentUseCase.execute(Student(
        email: email,
        password: password,
        name: name,
        surname: surname,
      ));

      state = state.copyWith(isLoading: false, student: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>(
  (ref) => StudentNotifier(ref.watch(saveStudentUseCaseProvider)),
);
