import 'package:green_check/infrastructure/repositories/course_repository.dart';

class DeleteStudentCourseUseCase {
  final CourseRepository courseRepository;
  DeleteStudentCourseUseCase(this.courseRepository);

  Future<void> execute(String idStudent, String idCourse) async {
    courseRepository.deleteStudent(idStudent, idCourse);
  }
}
