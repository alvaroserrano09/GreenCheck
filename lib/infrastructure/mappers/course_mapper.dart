import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/entities/supabase_course.dart';

class CourseMapper {
  static SupabaseCourse toEntity(Course course) {
    return SupabaseCourse(
      id: course.id,
      nombre: course.name,
      idProfesor: course.idTeacher,
      descripcion: course.description,
      tipo: course.type,
    );
  }

  static Course toDomain(SupabaseCourse course, {bool isFavorite = false}) {
    return Course(
        id: course.id,
        name: course.nombre,
        idTeacher: course.idProfesor,
        description: course.descripcion,
        type: course.tipo,
        isFavorite: isFavorite);
  }
}
