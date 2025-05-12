import 'package:green_check/infrastructure/repositories/student_course_repository.dart';

class ToggleFavoriteCourseUseCase {
  final StudentCourseRepository studentCourseRepository;

  ToggleFavoriteCourseUseCase(this.studentCourseRepository);

  Future<void> execute(
      String courseId, bool isFavorite, String idStudent) async {
    try {
      await studentCourseRepository.toggleFavorite(
          courseId, isFavorite, idStudent);
    } catch (e) {
      throw Exception('Error toggling favorite status: $e');
    }
  }
}
