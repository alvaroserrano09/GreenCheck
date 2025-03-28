import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';

class GetCourseStudentUseCase {
  final CourseRepository courseRepository;

  GetCourseStudentUseCase(this.courseRepository);

  Future<Course> execute(int idStudent) async {
    final response = await courseRepository.getCourse(idStudent);
    return response;
  }
}
