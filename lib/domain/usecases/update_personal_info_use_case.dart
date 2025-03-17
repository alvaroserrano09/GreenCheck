import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class UpdatePersonalInfoUseCase {
  final UserRepository userRepository;
  UpdatePersonalInfoUseCase(this.userRepository);

  Future<User> execute(
      String email, String name, String surname, String role) async {
    if (role == 'profesor') {
      User teacherSaved = await userRepository.updatePersonalInfoTeacher(
        email,
        name,
        surname,
      );
      return teacherSaved;
    } else if (role == 'alumno') {
      User studentSaved = await userRepository.updatePersonalInfoStudent(
        email,
        name,
        surname,
      );
      return studentSaved;
    } else {
      throw Exception('Invalid role: $role');
    }
  }
}
