import 'package:green_check/domain/models/course.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class CourseService {
  Future<Course> saveCourse(Course course) async {
    try {
      await supabase.from("Curso").insert({
        'nombre': course.name,
        'descripcion': course.description,
        'id_profesor': course.idTeacher,
        'tipo': course.type,
      });
      return course;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Course>> getCourses(int id) async {
    try {
      final response =
          await supabase.from('Curso').select().eq('id_profesor', id);

      return response
          .map((courseData) => Course(
                id: courseData['id'],
                name: courseData['nombre'],
                description: courseData['descripcion'],
                idTeacher: courseData['id_profesor'],
                type: courseData['tipo'],
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Course>> getCoursesForStudent(int studentId) async {
    final response = await supabase.from('Alumno-curso').select('''
          Curso: id_curso (id, nombre, descripcion, id_profesor, tipo)
      ''').eq('id_alumno', studentId);
    final List<Course> courses = response.map((courseData) {
      final curso = courseData['Curso'];

      if (curso['nombre'] == null ||
          curso['descripcion'] == null ||
          curso['tipo'] == null) {
        throw Exception('Datos incompletos para el curso');
      }

      return Course(
        id: curso['id'],
        name: curso['nombre'],
        description: curso['descripcion'],
        idTeacher: curso['id_profesor'],
        type: curso['tipo'],
      );
    }).toList();

    return courses;
  }

  Future<Course?> getCourse(int idStudent) async {
    try {
      print('idStudent $idStudent');
      final response = await supabase
          .from('Curso')
          .select()
          .eq('id', idStudent)
          .maybeSingle();
      return Course.fromJson(response!);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
