import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';

class GetCoursesStudentUseCase {
  final StudentCourseRepository studentCourseRepository;
  final StudentRepository studentRepository;
  final TeacherRepository teacherRepository;
  GetCoursesStudentUseCase(this.studentCourseRepository, this.studentRepository,
      this.teacherRepository);
  Future<List<Course>> execute(String idStudent) async {
    try {
      final List<Course> courses =
          await studentCourseRepository.getCoursesForStudent(idStudent);

      final List<Course> newCourses = [];

      for (final course in courses) {
        final teacher =
            await teacherRepository.getTeacherById(course.idTeacher);

        newCourses.add(Course(
          id: course.id,
          name: course.name,
          idTeacher: course.idTeacher,
          teacherName: teacher?.name,
          description: course.description,
          type: course.type,
          isFavorite: course.isFavorite,
        ));
      }

      return newCourses;
    } catch (e) {
      throw Exception('Error al obtener cursos: $e');
    }
  }
}
