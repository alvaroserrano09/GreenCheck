import 'package:green_check/domain/models/user.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

class UserRepository {
  final UserService datasource;
  UserRepository(this.datasource);

  Future<User> saveStudent(User student) {
    return datasource.saveStudent(student);
  }

  authStudent(String email, String password) {
    return datasource.authStudent(email, password);
  }
}
