import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';

class GetStudentsCourseUseCase {
  final StudentCourseRepository studentCourseRepository;

  GetStudentsCourseUseCase(this.studentCourseRepository);

  Future<List<User>> execute(String courseId) async {
    final response = await studentCourseRepository.getStudents(courseId);
    return response;
  }
}
