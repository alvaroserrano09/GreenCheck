import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/services/course_service.dart';

class CourseRepository {
  final CourseService datasource;
  CourseRepository(this.datasource);

  saveCourse(Course student) {
    return datasource.saveCourse(student);
  }

  getCourses(String idTeacher) {
    return datasource.getCourses(idTeacher);
  }

  getCourse(String idStudent) {
    return datasource.getCourse(idStudent);
  }

  Future<void> deleteCourse(String courseId) {
    return datasource.deleteCourse(courseId);
  }
}
