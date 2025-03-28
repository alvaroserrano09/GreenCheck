import 'dart:async';

import 'package:green_check/domain/models/user.dart' as user;
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class UserService {
  Future<user.User> saveStudent(user.User student) async {
    try {
      final studentDatabase = await supabase.from("Alumno").insert({
        'nombre': student.name,
        'email': student.email,
        'apellidos': student.surname,
        'contrasena': student.password,
      }).select();
      final studentSaved = user.User.fromJson(studentDatabase[0]);
      await Supabase.instance.client.auth.signUp(
        email: student.email,
        password: student.password,
      );
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

      final userData = response.user;
      if (userData == null) {
        throw Exception("No se pudo autenticar al usuario.");
      }

      final student = await Supabase.instance.client
          .from("Alumno")
          .select("nombre, email, apellidos,id,contrasena,rol")
          .eq('email', email)
          .maybeSingle();
      if (student == null || student.isEmpty) {
        final teacherUser = await Supabase.instance.client
            .from("Profesor")
            .select("nombre, email, apellidos,id,contrasena,rol")
            .eq('email', email)
            .single();
        if (teacherUser.isEmpty) {
          throw Exception("No se pudo autenticar al usuario.");
        }
        return user.User.fromJson(teacherUser);
      }

      return user.User.fromJson(student);
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
      final response = user.User.fromJson(userUpdated[0]);
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
      final response = user.User.fromJson(userUpdated[0]);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<user.User> getStudentByEmail(String email) async {
    try {
      final student = await supabase
          .from('Alumno')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (student == null || student.isEmpty) {
        throw Exception(
            'No se encontró un estudiante con el email proporcionado.');
      }

      return user.User.fromJson(student);
    } catch (e) {
      rethrow;
    }
  }
}
