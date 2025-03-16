import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class UpdatePersonalInfoUseCase {
  final UserRepository userRepository;
  UpdatePersonalInfoUseCase(this.userRepository);

  Future<User> execute(
      {required email, required String name, required surname}) async {
    User studentSaved =
        await userRepository.updatePersonalInfo(email, name, surname);
    return studentSaved;
  }
}
