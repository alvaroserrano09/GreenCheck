import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class UpdatePasswordUseCase {
  final UserRepository _userRepository;

  UpdatePasswordUseCase(this._userRepository);

  Future<User> execute(String password, String email, String role) async {
    if (role == 'profesor') {
      final userUpdated =
          await _userRepository.updatePasswordTeacher(password, email);
      return userUpdated;
    } else if (role == 'alumno') {
      final userUpdated =
          await _userRepository.updatePasswordStudent(password, email);
      return userUpdated;
    } else {
      throw Exception('Invalid role: $role');
    }
  }
}
