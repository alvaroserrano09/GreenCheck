import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class GetTeacherByIdUseCase {
  final UserRepository _teacherRepository;

  GetTeacherByIdUseCase(this._teacherRepository);

  Future<User?> execute(int id) async {
    return await _teacherRepository.getTeacherById(id);
  }
}
