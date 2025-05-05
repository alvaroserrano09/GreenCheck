import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class SaveStudentUseCase {
  final StudentRepository studentRepository;
  SaveStudentUseCase(this.studentRepository);

  Future<User> execute(User student, String passsword) async {
    User studentSaved = await studentRepository.saveStudent(student, passsword);
    return studentSaved;
  }
}
