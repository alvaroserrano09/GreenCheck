import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';

class SaveStudentGoogleUseCase {
  final StudentRepository studentRepository;
  final TeacherRepository teacherRepository;
  SaveStudentGoogleUseCase(this.studentRepository, this.teacherRepository);

  Future<User> execute(User user) async {
    try {
      final existingUser =
          await studentRepository.getStudentByEmail(user.email);

      if (existingUser != null) {
        return existingUser;
      }

      final existingTeacher =
          await teacherRepository.getTeacherByEmail(user.email);

      if (existingTeacher != null) {
        return existingTeacher;
      }

      return await studentRepository.saveStudent(user, "");
    } catch (e) {
      throw Exception("Error al procesar usuario de Google: $e");
    }
  }
}
