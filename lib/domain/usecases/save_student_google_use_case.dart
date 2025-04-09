import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class SaveStudentGoogleUseCase {
  final UserRepository userRepository;

  SaveStudentGoogleUseCase(this.userRepository);

  Future<User> execute(User user) async {
    try {
      final existingUser = await userRepository.getStudentByEmail(user.email);

      if (existingUser != null) {
        return existingUser;
      }

      final existingTeacher =
          await userRepository.getTeacherByEmail(user.email);

      if (existingTeacher != null) {
        return existingTeacher;
      }

      return await userRepository.saveStudent(user, "");
    } catch (e) {
      throw Exception("Error al procesar usuario de Google: $e");
    }
  }
}
