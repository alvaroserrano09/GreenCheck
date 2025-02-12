import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/student.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

class StudentProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isRegistered = false;

  final _studentService = StudentService();

  Future<void> registerStudent({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    isLoading = true;
    errorMessage = null;
    isRegistered = false;
    notifyListeners();

    try {
      await _studentService.saveStudent(Student(
        id: 1, // O usa un ID generado
        email: email,
        password: password,
        name: name,
        surname: surname,
      ));

      isRegistered = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// 🔥 Mantén ChangeNotifierProvider
final studentProvider = ChangeNotifierProvider<StudentProvider>(
  (ref) => StudentProvider(),
);
