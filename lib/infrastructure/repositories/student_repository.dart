import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

class UserRepository {
  final UserService datasource;
  UserRepository(this.datasource);

  Future<User> saveStudent(User student) {
    return datasource.saveStudent(student);
  }

  Future<User> authStudent(String email, String password) {
    return datasource.authStudent(email, password);
  }

  Future<User> updatePersonalInfoTeacher(
      String email, String name, String surname) {
    return datasource.updatePersonalInfoTeacher(email, name, surname);
  }

  Future<User> updatePersonalInfoStudent(
      String email, String name, String surname) {
    return datasource.updatePersonalInfoStudent(email, name, surname);
  }
}
