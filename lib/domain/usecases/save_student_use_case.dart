import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class SaveStudentUseCase {
  final UserRepository userRepository;
  SaveStudentUseCase(this.userRepository);

  Future<User> execute(User student, String passsword) async {
    User studentSaved = await userRepository.saveStudent(student, passsword);
    return studentSaved;
  }
}
