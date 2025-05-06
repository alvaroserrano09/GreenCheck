import 'package:green_check/domain/models/course.dart';
import 'package:green_check/infrastructure/entities/supabase_course.dart';
import 'package:green_check/infrastructure/entities/supabase_student.dart';
import 'package:green_check/infrastructure/mappers/course_mapper.dart';
import 'package:green_check/infrastructure/mappers/user_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:green_check/domain/models/user.dart' as user;

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

  Future<List<Course>> getCoursesForStudent(String studentId) async {
    try {
      final response = await supabase.from('Alumno-curso').select('''
          Curso: id_curso (id, nombre, descripcion, id_profesor, tipo),
          favorito
        ''').eq('id_alumno', studentId);

      final List<Course> courses = [];

      for (final item in response) {
        final curso = item['Curso'];
        final isFavorite = item['favorito'];

        courses.add(Course(
          id: curso['id'] as String,
          name: curso['nombre'] as String,
          description: curso['descripcion'] as String,
          idTeacher: curso['id_profesor'] as String,
          type: curso['tipo'] as String,
          isFavorite: isFavorite,
        ));
      }

      return courses;
    } catch (e) {
      throw Exception('No se pudieron cargar los cursos: ${e.toString()}');
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

  Future<List<user.User>> getStudents(String courseId) async {
    try {
      final response = await supabase.from('Alumno-curso').select('''
          Alumno: id_alumno (id, nombre, email,apellidos)
      ''').eq('id_curso', courseId);
      return response.map<user.User>((studentData) {
        final student = studentData['Alumno'];
        final studentEntity = SupabaseStudent.fromJson(student);

        return UserMapper.toDomainStudent(studentEntity);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<user.User> saveStudent(String courseId, String idStudent) async {
    try {
      await supabase.from('Alumno-curso').insert({
        'id_curso': courseId,
        'id_alumno': idStudent,
      });

      final response = await supabase
          .from('Alumno')
          .select()
          .eq('id', idStudent)
          .maybeSingle();

      if (response == null) {
        throw Exception('Student not found');
      }

      return user.User(
        id: response['id'],
        name: response['nombre'],
        email: response['email'],
        surname: response['apellidos'],
      );
    } catch (e) {
      throw Exception('Failed to save student: $e');
    }
  }

  Future<void> deleteStudent(String idStudent, String idCourse) async {
    try {
      await supabase
          .from('Alumno-curso')
          .delete()
          .eq('id_alumno', idStudent)
          .eq('id_curso', idCourse);
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  Future<void> toggleFavorite(
      String studentId, String courseId, bool isFavorite) async {
    try {
      await supabase
          .from('Alumno-curso')
          .update({'favorito': isFavorite})
          .eq('id_alumno', studentId)
          .eq('id_curso', courseId);
    } catch (e) {
      throw Exception(
          'No se pudo actualizar el estado de favorito: ${e.toString()}');
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
