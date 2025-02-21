import 'package:green_check/domain/models/student.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

class StudentRepository {
  final StudentService datasource;
  StudentRepository(this.datasource);

  Future<Student> saveStudent(Student student) {
    return datasource.saveStudent(student);
  }

  authStudent(String email, String password) {
    return datasource.authStudent(email, password);
  }
}
