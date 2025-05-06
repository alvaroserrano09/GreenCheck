import 'package:green_check/infrastructure/repositories/course_repository.dart';

class DeleteCourseUseCase {
  final CourseRepository courseRepository;

  DeleteCourseUseCase(this.courseRepository);

  Future<void> execute(String courseId) async {
    await courseRepository.deleteCourse(courseId);
  }
}
