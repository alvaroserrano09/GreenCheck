import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/entities/supabase_student.dart';
import 'package:green_check/infrastructure/entities/supabase_teacher.dart';

class UserMapper {
  static SupabaseStudent toEntity(User user) {
    return SupabaseStudent(
      id: user.id,
      email: user.email,
      nombre: user.name,
      apellidos: user.surname,
    );
  }

  static User toDomainStudent(SupabaseStudent user) {
    return User(
      email: user.email,
      name: user.nombre,
      surname: user.apellidos,
      role: "alumno",
      id: user.id,
    );
  }

  static User toDomainTeacher(SupabaseTeacher user) {
    return User(
      email: user.email,
      name: user.nombre,
      surname: user.apellidos,
      role: "profesor",
      id: user.id,
    );
  }
}
