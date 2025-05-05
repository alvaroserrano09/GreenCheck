import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';

class GetTeacherUseCase {
  final TeacherRepository teacherRepository;

  GetTeacherUseCase(this.teacherRepository);

  Future<User?> call(String email) async {
    return await teacherRepository.getTeacherByEmail(email);
  }
}
