import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';

class SaveCourseUseCase {
  final CourseRepository courseRepository;
  SaveCourseUseCase(this.courseRepository);

  Future<Course> execute(Course course) async {
    Course courseSaved = await courseRepository.saveCourse(course);
    return courseSaved;
  }
}
