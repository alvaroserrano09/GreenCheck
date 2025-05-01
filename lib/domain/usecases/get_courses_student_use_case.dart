import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class GetCoursesStudentUseCase {
  final CourseRepository courseRepository;
  final UserRepository studentRepository;
  GetCoursesStudentUseCase(this.courseRepository, this.studentRepository);
  Future<List<Course>> execute(int idStudent) async {
    try {
      final List<Course> courses =
          await courseRepository.getCoursesForStudent(idStudent);

      final List<Course> updatedCourses = [];

      for (final course in courses) {
        final teacher =
            await studentRepository.getTeacherById(course.idTeacher);

        updatedCourses.add(Course(
          id: course.id,
          name: course.name,
          idTeacher: course.idTeacher,
          teacherName: teacher?.name,
          description: course.description,
          type: course.type,
          isFavorite: course.isFavorite,
        ));
      }

      return updatedCourses;
    } catch (e) {
      throw Exception('Error al obtener cursos: $e');
    }
  }
}
