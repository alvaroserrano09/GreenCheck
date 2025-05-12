import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class SaveStudentCourseUseCase {
  final StudentCourseRepository studentCourseRepository;
  final StudentRepository studentRepositoy;

  SaveStudentCourseUseCase(this.studentCourseRepository, this.studentRepositoy);

  Future<User> execute(String idCourse, String email) async {
    final student = await studentRepositoy.getStudentByEmail(email);
    final response =
        await studentCourseRepository.saveStudent(idCourse, student!.id);
    return response;
  }
}
