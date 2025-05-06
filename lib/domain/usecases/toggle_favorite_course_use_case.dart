import 'package:green_check/infrastructure/repositories/course_repository.dart';

class ToggleFavoriteCourseUseCase {
  final CourseRepository courseRepository;

  ToggleFavoriteCourseUseCase(this.courseRepository);

  Future<void> execute(
      String courseId, bool isFavorite, String idStudent) async {
    try {
      await courseRepository.toggleFavorite(courseId, isFavorite, idStudent);
    } catch (e) {
      throw Exception('Error toggling favorite status: $e');
    }
  }
}
