import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class GetStudentUseCase {
  final StudentRepository studentRepository;

  GetStudentUseCase(this.studentRepository);

  Future<User?> execute(String email) async {
    return await studentRepository.getStudentByEmail(email);
  }
}
