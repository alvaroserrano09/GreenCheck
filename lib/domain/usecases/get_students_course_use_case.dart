import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';

class GetStudentsCourseUseCase {
  final CourseRepository courseRepository;

  GetStudentsCourseUseCase(this.courseRepository);

  Future<List<User>> execute(String courseId) async {
    final response = await courseRepository.getStudents(courseId);
    return response;
  }
}
