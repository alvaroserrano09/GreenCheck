import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';

class GetCoursesTeacherUseCase {
  final CourseRepository courseRepository;

  GetCoursesTeacherUseCase(this.courseRepository);

  Future<List<Course>> execute(String idTeacher) async {
    return await courseRepository.getCourses(idTeacher);
  }
}
