import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class GetStudentUseCase {
  final UserRepository repository;

  GetStudentUseCase(this.repository);

  Future<User?> execute(String email) async {
    return await repository.getStudentByEmail(email);
  }
}
