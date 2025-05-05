import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class AuthenticateStudentUseCase {
  final StudentRepository studentRepository;
  AuthenticateStudentUseCase(this.studentRepository);

  Future<User> execute(
      {required String email, required String password}) async {
    User authStudent = await studentRepository.authStudent(email, password);
    return authStudent;
  }
}
