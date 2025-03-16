import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/domain/usecases/authenticate_student_use_case.dart';
import 'package:green_check/domain/usecases/save_student_use_case.dart';
import 'package:green_check/domain/usecases/update_personal_info_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(UserService());
});
final authenticatUseCaseProvider = Provider<AuthenticateStudentUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthenticateStudentUseCase(userRepository);
});

final saveStudentUseCaseProvider = Provider<SaveStudentUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return SaveStudentUseCase(userRepository);
});

final updatePersonalInfoUseCase = Provider<UpdatePersonalInfoUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UpdatePersonalInfoUseCase(userRepository);
});

class UserState {
  final bool isLoading;
  final String? errorMessage;
  final User? student;

  UserState({
    required this.isLoading,
    this.errorMessage,
    this.student,
  });

  UserState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? student,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      student: student ?? this.student,
    );
  }

  factory UserState.initial() => UserState(isLoading: false);
}

class StudentNotifier extends StateNotifier<UserState> {
  final SaveStudentUseCase saveStudentUseCase;
  final AuthenticateStudentUseCase authenticateStudentUseCase;
  final UpdatePersonalInfoUseCase updatePersonalInfoUseCase;

  StudentNotifier(this.saveStudentUseCase, this.authenticateStudentUseCase,
      this.updatePersonalInfoUseCase)
      : super(UserState.initial());

  Future<void> registerStudent({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await saveStudentUseCase.execute(User(
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
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await authenticateStudentUseCase.execute(
        email: email,
        password: password,
      );

      state = state.copyWith(isLoading: false, student: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }

  Future<void> updatePersonalInfo(
      {required String email,
      required String name,
      required String surname}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await updatePersonalInfoUseCase.execute(
        email: email,
        name: name,
        surname: surname,
      );
      state = state.copyWith(isLoading: false, student: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, UserState>(
  (ref) => StudentNotifier(
      ref.watch(saveStudentUseCaseProvider),
      ref.watch(authenticatUseCaseProvider),
      ref.watch(updatePersonalInfoUseCase)),
);
