import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/student.dart';
import 'package:green_check/domain/usecases/authenticate_student_use_case.dart';
import 'package:green_check/domain/usecases/save_student_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

// Definición de los Providers
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(StudentService());
});
final authenticatUseCaseProvider = Provider<AuthenticateStudentUseCase>((ref) {
  final studentRepository = ref.watch(studentRepositoryProvider);
  return AuthenticateStudentUseCase(studentRepository);
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
  final AuthenticateStudentUseCase authenticateStudentUseCase;

  StudentNotifier(this.saveStudentUseCase, this.authenticateStudentUseCase)
      : super(StudentState.initial());

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
      throw Exception(e);
    }
  }

  Future<void> loginStudent({
    required String email,
    required String password,
  }) async {
    // Activa el estado de carga y limpia cualquier mensaje de error previo
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Llama al caso de uso para autenticar al estudiante
      final response = await authenticateStudentUseCase.execute(
        email: email,
        password: password,
      );

      // Actualiza el estado con el estudiante autenticado y desactiva la carga
      state = state.copyWith(isLoading: false, student: response);
    } catch (e) {
      // Si hay un error, actualiza el estado con el mensaje de error y desactiva la carga
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>(
  (ref) => StudentNotifier(ref.watch(saveStudentUseCaseProvider),
      ref.watch(authenticatUseCaseProvider)),
);
