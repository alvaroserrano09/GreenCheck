import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/user.dart';
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

  getCoursesForStudent(String idStudent) {
    return datasource.getCoursesForStudent(idStudent);
  }

  getCourse(String idStudent) {
    return datasource.getCourse(idStudent);
  }

  Future<List<User>> getStudents(String courseId) async {
    return datasource.getStudents(courseId);
  }

  Future<User> saveStudent(String courseId, String idStudent) {
    return datasource.saveStudent(courseId, idStudent);
  }

  Future<void> deleteStudent(String idStudent, String idCourse) {
    return datasource.deleteStudent(idStudent, idCourse);
  }

  Future<void> toggleFavorite(
      String courseId, bool isFavorite, String idStudent) {
    return datasource.toggleFavorite(idStudent, courseId, isFavorite);
  }
}
