import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class SaveStudentCourseUseCase {
  final StudentCourseRepository studentCourseRepository;
  final StudentRepository studentRepository;

  SaveStudentCourseUseCase(
      this.studentCourseRepository, this.studentRepository);

  Future<User> execute(String idCourse, String email) async {
    final student = await studentRepository.getStudentByEmail(email);
    final response =
        await studentCourseRepository.saveStudent(idCourse, student!.id);
    return response;
  }
}
