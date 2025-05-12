import 'package:green_check/infrastructure/repositories/student_course_repository.dart';

class DeleteStudentCourseUseCase {
  final StudentCourseRepository studentCourseRepository;
  DeleteStudentCourseUseCase(this.studentCourseRepository);

  Future<void> execute(String idStudent, String idCourse) async {
    studentCourseRepository.deleteStudent(idStudent, idCourse);
  }
}
