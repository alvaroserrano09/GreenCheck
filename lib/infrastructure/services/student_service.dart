import 'dart:async';

import 'package:green_check/domain/models/user.dart' as user;
import 'package:green_check/infrastructure/entities/supabase_student.dart';
import 'package:green_check/infrastructure/mappers/user_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class UserService {
  Future<user.User> saveStudent(user.User student, password) async {
    try {
      final studentDatabase = await supabase
          .from("Alumno")
          .insert(
            UserMapper.toEntity(student).toJsonStudent(),
          )
          .select();
      final studentEntity = SupabaseStudent.fromJson(studentDatabase[0]);
      final studentSaved = UserMapper.toDomainStudent(studentEntity);
      if (password != "") {
        await Supabase.instance.client.auth.signUp(
          email: student.email,
          password: password,
        );
      }
      return studentSaved;
    } catch (e) {
      rethrow;
    }
  }

  Future<user.User> authStudent(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("No se pudo autenticar al usuario.");
      }

      final student = await Supabase.instance.client
          .from("Alumno")
          .select("nombre, email, apellidos, id")
          .eq('email', email)
          .maybeSingle();

      if (student != null) {
        final studentEntity = SupabaseStudent.fromJson(
          student,
        );
        return UserMapper.toDomainStudent(studentEntity);
      }

      final teacherUser = await Supabase.instance.client
          .from("Profesor")
          .select("nombre, email, apellidos, id")
          .eq('email', email)
          .maybeSingle();
      if (teacherUser != null) {
        final teacherEntity = SupabaseStudent.fromJson(
          teacherUser,
        );
        return UserMapper.toDomainTeacher(teacherEntity);
      }

      throw Exception("Usuario no encontrado como alumno ni como profesor");
    } catch (e) {
      rethrow;
    }
  }

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
        SupabaseStudent.fromJson(userUpdated[0]),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<user.User> updatePersonalInfoStudent(
      String email, String name, String surname) async {
    try {
      if (email.isEmpty || name.isEmpty || surname.isEmpty) {
        throw Exception('Todos los campos son obligatorios');
      }

      final userUpdated = await supabase
          .from('Alumno')
          .update({
            'nombre': name,
            'apellidos': surname,
          })
          .eq('email', email)
          .select();
      final response = UserMapper.toDomainStudent(
        SupabaseStudent.fromJson(userUpdated[0]),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<user.User?> getStudentByEmail(String email) async {
    try {
      final student = await supabase
          .from('Alumno')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (student == null || student.isEmpty) {
        return null;
      }

      return UserMapper.toDomainStudent(
        SupabaseStudent.fromJson(student),
      );
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
        SupabaseStudent.fromJson(teacher),
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
        SupabaseStudent.fromJson(teacher),
      );
    } catch (e) {
      rethrow;
    }
  }
}
