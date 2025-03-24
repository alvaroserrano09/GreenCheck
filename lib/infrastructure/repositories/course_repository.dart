import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/services/course_service.dart';

class CourseRepository {
  final CourseService datasource;
  CourseRepository(this.datasource);

  saveCourse(Course student) {
    return datasource.saveCourse(student);
  }

  getCourses(int idTeacher) {
    return datasource.getCourses(idTeacher);
  }

  getCoursesForStudent(int idStudent) {
    return datasource.getCoursesForStudent(idStudent);
  }

  getCourse(int idStudent) {
    return datasource.getCourse(idStudent);
  }
}
