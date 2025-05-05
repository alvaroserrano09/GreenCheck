import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';

class GetTeacherByIdUseCase {
  final TeacherRepository teacherRepository;

  GetTeacherByIdUseCase(this.teacherRepository);

  Future<User?> execute(String id) async {
    return await teacherRepository.getTeacherById(id);
  }
}
