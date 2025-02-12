import 'package:green_check/domain/models/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentService {
  Future<Student> saveStudent(Student student) async {
    try {
      await Supabase.instance.client.from("Alumno").insert({
        'nombre': student.name,
        'email': student.email,
        'apellidos': student.surname,
        'contrasena': student.password,
      });
      return student;
    } catch (e) {
      print("Error saving student: $e");
      rethrow;
    }
  }
}
