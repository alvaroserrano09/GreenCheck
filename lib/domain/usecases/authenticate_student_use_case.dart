import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class AuthenticateStudentUseCase {
  final UserRepository userRepository;
  AuthenticateStudentUseCase(this.userRepository);

  Future<User> execute(
      {required String email, required String password}) async {
    User authStudent = await userRepository.authStudent(email, password);
    return authStudent;
  }
}
