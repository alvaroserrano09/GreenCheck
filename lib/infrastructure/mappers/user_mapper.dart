import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/entities/supabase_student.dart';

class UserMapper {
  static SupabaseStudent toEntity(User user) {
    return SupabaseStudent(
      email: user.email,
      nombre: user.name,
      apellidos: user.surname,
      contrasena: user.password,
      rol: user.role,
    );
  }

  static User toDomain(SupabaseStudent user) {
    return User(
      email: user.email,
      id: user.id,
      name: user.nombre,
      surname: user.apellidos,
      password: user.contrasena,
      role: user.rol,
    );
  }
}
