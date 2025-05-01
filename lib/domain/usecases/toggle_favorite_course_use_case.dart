import 'package:green_check/infrastructure/repositories/course_repository.dart';

class ToggleFavoriteCourseUseCase {
  final CourseRepository courseRepository;

  ToggleFavoriteCourseUseCase(this.courseRepository);

  Future<void> execute(int courseId, bool isFavorite, int idStudent) async {
    try {
      await courseRepository.toggleFavorite(courseId, isFavorite, idStudent);
    } catch (e) {
      throw Exception('Error toggling favorite status: $e');
    }
  }
}
