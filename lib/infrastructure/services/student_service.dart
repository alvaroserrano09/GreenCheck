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
      return studentSaved;
    } catch (e) {
      rethrow;
    }
  }

  Future<user.User> authStudent(String email, String password) async {
    try {
      final student = await supabase
          .from('Alumno')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (student == null || student.isEmpty) {
        final teacher = await supabase
            .from('Profesor')
            .select()
            .eq('email', email)
            .maybeSingle();

        if (teacher == null || teacher.isEmpty) {
          throw Exception('Email no registrado');
        }
        if (teacher['contrasena'] != password) {
          throw Exception('Contraseña incorrecta');
        }
        final userAuth = user.User.fromJson(teacher);

        return userAuth;
      }

      if (student['contrasena'] != password) {
        throw Exception('Contraseña incorrecta');
      }
      final studentUser = user.User.fromJson(student);

      return studentUser;
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
}
