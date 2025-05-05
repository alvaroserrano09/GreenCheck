import 'package:green_check/domain/models/user.dart' as user;
import 'package:green_check/infrastructure/entities/supabase_teacher.dart';
import 'package:green_check/infrastructure/mappers/user_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<user.User> updatePersonalInfoTeacher(
    String email,
    String name,
    String surname,
  ) async {
    try {
      if (email.isEmpty || name.isEmpty || surname.isEmpty) {
        throw Exception('Todos los campos son obligatorios');
      }

      final userUpdated = await supabase
          .from('Profesor')
          .update({
            'nombre': name,
            'apellidos': surname,
          })
          .eq('email', email)
          .select();
      final response = UserMapper.toDomainTeacher(
        SupabaseTeacher.fromJson(userUpdated[0]),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<user.User?> getTeacherByEmail(String email) async {
    try {
      final teacher = await supabase
          .from('Profesor')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (teacher == null || teacher.isEmpty) {
        return null;
      }

      return UserMapper.toDomainTeacher(
        SupabaseTeacher.fromJson(teacher),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<user.User?> getTeacherById(String id) async {
    try {
      final teacher =
          await supabase.from('Profesor').select().eq('id', id).maybeSingle();

      if (teacher == null || teacher.isEmpty) {
        return null;
      }

      return UserMapper.toDomainTeacher(
        SupabaseTeacher.fromJson(teacher),
      );
    } catch (e) {
      rethrow;
    }
  }
}
