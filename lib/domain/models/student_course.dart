import 'package:uuid/uuid.dart';

class StudentCourse {
  final String id;
  final String studentId;
  final String courseId;
  bool isFavorite;

  StudentCourse({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.isFavorite = false,
  });

  factory StudentCourse.create({
    required String studentId,
    required String courseId,
  }) {
    final uuid = const Uuid().v4();
    return StudentCourse(
      id: uuid,
      studentId: studentId,
      courseId: courseId,
      isFavorite: false,
    );
  }
}
