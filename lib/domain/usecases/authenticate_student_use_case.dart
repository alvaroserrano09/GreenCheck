import 'package:green_check/domain/models/student.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class AuthenticateStudentUseCase {
  final StudentRepository studentRepository;
  AuthenticateStudentUseCase(this.studentRepository);

  Future<Student> execute(
      {required String email, required String password}) async {
    Student authStudent = await studentRepository.authStudent(email, password);
    return authStudent;
  }
}
