import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/services/student_course_service.dart';

class StudentCourseRepository {
  final StudentCourseService datasource;
  StudentCourseRepository(this.datasource);

  Future<List<User>> getStudents(String courseId) async {
    return datasource.getStudents(courseId);
  }

  Future<List<Course>> getCoursesForStudent(String idStudent) {
    return datasource.getCoursesForStudent(idStudent);
  }

  Future<void> deleteStudent(String idStudent, String idCourse) {
    return datasource.deleteStudent(idStudent, idCourse);
  }

  Future<void> toggleFavorite(
      String courseId, bool isFavorite, String idStudent) {
    return datasource.toggleFavorite(idStudent, courseId, isFavorite);
  }

  Future<User> saveStudent(String courseId, String idStudent) {
    return datasource.saveStudent(courseId, idStudent);
  }
}
