import 'package:green_check/domain/models/student.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';

class SaveStudentUseCase {
  final StudentRepository studentRepository;
  SaveStudentUseCase(this.studentRepository);

  Future<Student> execute(Student student) async {
    Student studentSaved = await studentRepository.saveStudent(student);
    return studentSaved;
  }
}
