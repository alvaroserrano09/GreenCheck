import 'package:green_check/domain/models/studentCourse.dart';
import 'package:green_check/infrastructure/entities/supabase_course_teacher.dart';

class StudentCourseMapper {
  static SupabaseStudentCourse toEntity(StudentCourse studentCourse) {
    return SupabaseStudentCourse(
      id: studentCourse.id,
      idAlumno: studentCourse.studentId,
      idCurso: studentCourse.courseId,
      favorito: studentCourse.isFavorite,
    );
  }

  static StudentCourse toDomain(Map<String, dynamic> json) {
    return StudentCourse(
      id: json['id'],
      studentId: json['studentId'],
      courseId: json['courseId'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
