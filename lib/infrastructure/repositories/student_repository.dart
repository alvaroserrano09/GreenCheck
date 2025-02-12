import 'package:green_check/domain/models/student.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

class StudentRepository {
  final StudentService datasource;
  StudentRepository(this.datasource);

  Future<Student> saveStudent(Student student) {
    print('Saving student...');
    return datasource.saveStudent(student);
  }
}
