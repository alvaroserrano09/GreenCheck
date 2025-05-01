import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/user.dart';
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

  Future<List<User>> getStudents(int courseId) async {
    return datasource.getStudents(courseId);
  }

  Future<User> saveStudent(int courseId, int idStudent) {
    return datasource.saveStudent(courseId, idStudent);
  }

  Future<void> deleteStudent(int idStudent, int idCourse) {
    return datasource.deleteStudent(idStudent, idCourse);
  }

  Future<void> toggleFavorite(int courseId, bool isFavorite, int idStudent) {
    return datasource.toggleFavorite(idStudent, courseId, isFavorite);
  }
}
