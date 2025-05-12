import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/entities/supabase_course.dart';
import 'package:green_check/infrastructure/mappers/course_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class CourseService {
  Future<Course> saveCourse(Course course) async {
    try {
      await supabase.from("Curso").insert(
            CourseMapper.toEntity(course).toJson(),
          );
      return course;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Course>> getCourses(String id) async {
    try {
      final response =
          await supabase.from('Curso').select().eq('id_profesor', id);

      return response
          .map((courseData) => CourseMapper.toDomain(
                SupabaseCourse.fromJson(courseData),
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Course?> getCourse(String idStudent) async {
    try {
      final response = await supabase
          .from('Curso')
          .select()
          .eq('id', idStudent)
          .maybeSingle();
      if (response != null) {
        final courseEntity = SupabaseCourse.fromJson(response);

        return CourseMapper.toDomain(courseEntity);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCourse(String courseId) {
    try {
      return supabase.from('Curso').delete().eq('id', courseId);
    } catch (e) {
      throw Exception('No se pudo eliminar el curso: ${e.toString()}');
    }
  }
}
