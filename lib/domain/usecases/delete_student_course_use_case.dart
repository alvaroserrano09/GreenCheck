import 'package:green_check/infrastructure/repositories/course_repository.dart';

class DeleteStudentCourseUseCase {
  final CourseRepository courseRepository;
  DeleteStudentCourseUseCase(this.courseRepository);

  Future<void> execute(int idStudent, int idCourse) async {
    courseRepository.deleteStudent(idStudent, idCourse);
  }
}
