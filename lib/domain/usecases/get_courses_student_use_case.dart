import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';

class GetCoursesStudentUseCase {
  final CourseRepository courseRepository;

  GetCoursesStudentUseCase(this.courseRepository);

  Future<List<Course>> execute(int idStudent) async {
    return await courseRepository.getCoursesForStudent(idStudent);
  }
}
