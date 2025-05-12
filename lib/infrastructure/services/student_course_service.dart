import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/studentCourse.dart';
import 'package:green_check/infrastructure/entities/supabase_course.dart';
import 'package:green_check/infrastructure/entities/supabase_student.dart';
import 'package:green_check/infrastructure/mappers/course_mapper.dart';
import 'package:green_check/infrastructure/mappers/student_course_mapper.dart';
import 'package:green_check/infrastructure/mappers/user_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:green_check/domain/models/user.dart' as user;

class StudentCourseService {
  final SupabaseClient supabase = Supabase.instance.client;

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

        courses.add(CourseMapper.toDomain(
          SupabaseCourse.fromJson(curso),
          isFavorite: isFavorite,
        ));
      }

      return courses;
    } catch (e) {
      throw Exception('No se pudieron cargar los cursos: ${e.toString()}');
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
      final response = await supabase
          .from('Alumno-curso')
          .update({'favorito': isFavorite})
          .eq('id_alumno', studentId)
          .eq('id_curso', courseId)
          .select(); // <-- Esto fuerza a Supabase a devolver los datos actualizados
      print(response);
    } catch (e) {
      throw Exception(
          'No se pudo actualizar el estado de favorito: ${e.toString()}');
    }
  }

  Future<user.User> saveStudent(String courseId, String idStudent) async {
    try {
      final student = StudentCourse.create(
        courseId: courseId,
        studentId: idStudent,
      );
      await supabase
          .from('Alumno-curso')
          .insert(StudentCourseMapper.toEntity(student));

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
}
