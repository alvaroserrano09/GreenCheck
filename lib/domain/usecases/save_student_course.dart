import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class SaveStudentCourseUseCase {
  final CourseRepository courseRepository;
  final StudentRepository studentRepositoy;

  SaveStudentCourseUseCase(this.courseRepository, this.studentRepositoy);

  Future<User> execute(String idCourse, String email) async {
    final student = await studentRepositoy.getStudentByEmail(email);
    final response = await courseRepository.saveStudent(idCourse, student!.id);
    return response;
  }
}
