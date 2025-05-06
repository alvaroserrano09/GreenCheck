import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';

class GetCourseStudentUseCase {
  final CourseRepository courseRepository;
  final TeacherRepository teacherRepository;

  GetCourseStudentUseCase(this.courseRepository, this.teacherRepository);

  Future<Course> execute(String courseId) async {
    final Course course = await courseRepository.getCourse(courseId);
    final teacher = await teacherRepository.getTeacherById(course.idTeacher);

    return Course(
      id: course.id,
      name: course.name,
      description: course.description,
      idTeacher: course.idTeacher,
      type: course.type,
      teacherName: teacher?.name,
      isFavorite: course.isFavorite,
    );
  }
}
