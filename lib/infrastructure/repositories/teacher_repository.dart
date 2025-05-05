import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/services/teacher_service.dart';

class TeacherRepository {
  final TeacherService datasource;
  TeacherRepository(this.datasource);
  Future<User> updatePersonalInfoTeacher(
      String email, String name, String surname) {
    return datasource.updatePersonalInfoTeacher(email, name, surname);
  }

  Future<User?> getTeacherByEmail(String email) {
    return datasource.getTeacherByEmail(email);
  }

  Future<User?> getTeacherById(String id) {
    return datasource.getTeacherById(id);
  }
}
