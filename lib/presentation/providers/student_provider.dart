import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/student.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

class StudentProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  final _studentService = StudentService();

  Future<Student> registerStudent({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _studentService.saveStudent(Student(
        id: 1,
        email: email,
        password: password,
        name: name,
        surname: surname,
      ));

      isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
    throw Exception('Failed to register student');
  }
}

final studentProvider = ChangeNotifierProvider<StudentProvider>(
  (ref) => StudentProvider(),
);
