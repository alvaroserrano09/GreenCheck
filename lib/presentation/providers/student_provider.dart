import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/usecases/save_student_google_use_case.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';
import 'package:green_check/infrastructure/services/teacher_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/domain/usecases/authenticate_student_use_case.dart';
import 'package:green_check/domain/usecases/save_student_use_case.dart';
import 'package:green_check/domain/usecases/update_personal_info_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(StudentService());
});
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository(TeacherService());
});

final authenticatUseCaseProvider = Provider<AuthenticateStudentUseCase>((ref) {
  final studentRepository = ref.watch(studentRepositoryProvider);
  return AuthenticateStudentUseCase(studentRepository);
});

final saveStudentUseCaseProvider = Provider<SaveStudentUseCase>((ref) {
  final studentRepository = ref.watch(studentRepositoryProvider);
  return SaveStudentUseCase(studentRepository);
});

final updatePersonalInfoUseCaseProvider =
    Provider<UpdatePersonalInfoUseCase>((ref) {
  final studentRepository = ref.watch(studentRepositoryProvider);
  return UpdatePersonalInfoUseCase(
      studentRepository, ref.watch(teacherRepositoryProvider));
});
final saveStudentGoogleUseCaseProvider =
    Provider<SaveStudentGoogleUseCase>((ref) {
  final studentRepository = ref.watch(studentRepositoryProvider);
  return SaveStudentGoogleUseCase(
      studentRepository, ref.watch(teacherRepositoryProvider));
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
  final SaveStudentGoogleUseCase saveStudentGoogleUseCase;

  StudentNotifier(
    this.saveStudentUseCase,
    this.authenticateStudentUseCase,
    this.updatePersonalInfoUseCase,
    this.saveStudentGoogleUseCase,
  ) : super(UserState.initial()) {
    _loadUserState();
  }

  Future<void> _loadUserState() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    final email = prefs.getString('user_email');
    final name = prefs.getString('user_name');
    final surname = prefs.getString('user_surname');
    final role = prefs.getString('user_role');

    if (email != null && name != null && surname != null && role != null) {
      state = state.copyWith(
        student: User(
          email: email,
          name: name,
          surname: surname,
          role: role,
          id: id ?? '',
        ),
      );
    }
  }

  Future<void> _saveUserState(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_surname', user.surname);
    await prefs.setString('user_role', user.role ?? '');
  }

  Future<void> _clearUserState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_surname');
    await prefs.remove('user_role');
  }

  Future<void> registerStudent({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await saveStudentUseCase.execute(
          User.create(
            email: email,
            name: name,
            surname: surname,
          ),
          password,
          role);

      await _saveUserState(response);

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
      await _saveUserState(response);

      state = state.copyWith(isLoading: false, student: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }

  Future<void> logoutStudent() async {
    await _clearUserState();

    state = state.copyWith(student: null);
  }

  Future<void> updatePersonalInfo({
    required String email,
    required String name,
    required String surname,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await updatePersonalInfoUseCase.execute(
        email,
        name,
        surname,
        role,
      );

      await _saveUserState(response);

      state = state.copyWith(isLoading: false, student: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }

  Future<void> signInWithGoogle(currentUser) async {
    try {
      if (currentUser != null) {
        final fullName =
            currentUser.userMetadata?['full_name']?.split(' ') ?? ['', ''];
        final user = User.create(
          email: currentUser.email!,
          name: fullName.first,
          surname: fullName.length > 1 ? fullName.sublist(1).join(' ') : '',
        );

        final response = await saveStudentGoogleUseCase.execute(user);

        state = state.copyWith(isLoading: false, student: response);
      }
    } catch (e) {
      rethrow;
    }
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, UserState>(
  (ref) => StudentNotifier(
    ref.watch(saveStudentUseCaseProvider),
    ref.watch(authenticatUseCaseProvider),
    ref.watch(updatePersonalInfoUseCaseProvider),
    ref.watch(saveStudentGoogleUseCaseProvider),
  ),
);
