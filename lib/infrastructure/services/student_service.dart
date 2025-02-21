import 'package:green_check/domain/models/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class StudentService {
  Future<Student> saveStudent(Student student) async {
    try {
      await supabase.from("Alumno").insert({
        'nombre': student.name,
        'email': student.email,
        'apellidos': student.surname,
        'contrasena': student.password,
      });
      return student;
    } catch (e) {
      rethrow;
    }
  }

  Future<Student> authStudent(String email, String password) async {
    try {
      // Busca al estudiante por su correo electrónico
      final data = await supabase
          .from('Alumno') // Asegúrate de que el nombre de la tabla sea correcto
          .select()
          .eq('email', email) // Filtra por el correo electrónico
          .maybeSingle(); // Usa maybeSingle para manejar casos donde no hay resultados

      // Verifica si se encontró un estudiante con ese correo electrónico
      if (data == null || data.isEmpty) {
        throw Exception(
            'No se encontró un estudiante con ese correo electrónico');
      }

      // Verifica si la contraseña coincide
      if (data['contrasena'] != password) {
        throw Exception('Contraseña incorrecta');
      }
      final student = Student.fromJson(data);

      return student;
    } catch (e) {
      rethrow;
    }
  }
}
