import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

class StudentRepository {
  final StudentService datasource;
  StudentRepository(this.datasource);

  Future<User> saveStudent(User student, String password) {
    return datasource.saveStudent(student, password);
  }

  Future<User> authStudent(String email, String password) {
    return datasource.authStudent(email, password);
  }

  Future<User> updatePersonalInfoStudent(
      String email, String name, String surname) {
    return datasource.updatePersonalInfoStudent(email, name, surname);
  }

  Future<User?> getStudentByEmail(String email) {
    return datasource.getStudentByEmail(email);
  }
}
