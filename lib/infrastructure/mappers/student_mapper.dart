import 'package:green_check/domain/models/student.dart';
import 'package:green_check/infrastructure/entities/supabase_student.dart';

class StudentMapper {
  static SupabaseStudent toEntity(Student student) {
    return SupabaseStudent(
        email: student.email,
        nombre: student.name,
        apellidos: student.surname,
        contrasena: student.password);
  }

  static Student toDomain(SupabaseStudent student) {
    return Student(
        email: student.email,
        id: student.id,
        name: student.nombre,
        surname: student.apellidos,
        password: student.contrasena);
  }
}
