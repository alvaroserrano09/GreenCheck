import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';

class UpdatePersonalInfoUseCase {
  final StudentRepository studentRepository;
  final TeacherRepository teacherRepository;
  UpdatePersonalInfoUseCase(this.studentRepository, this.teacherRepository);

  Future<User> execute(
      String email, String name, String surname, String role) async {
    if (role == 'profesor') {
      User teacherSaved = await teacherRepository.updatePersonalInfoTeacher(
        email,
        name,
        surname,
      );
      return teacherSaved;
    } else if (role == 'alumno') {
      User studentSaved = await studentRepository.updatePersonalInfoStudent(
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
