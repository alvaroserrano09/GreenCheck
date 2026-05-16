import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/save_course_use_case.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'save_course_use_case_test.mocks.dart';

@GenerateMocks([CourseRepository])
void main() {
  late SaveCourseUseCase saveCourseUseCase;
  late MockCourseRepository mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepository();
    saveCourseUseCase = SaveCourseUseCase(mockCourseRepository);
  });

  group('SaveCourseUseCase', () {
    final testCourse = InfoObjectMother.createCourse();
    test('should call saveCourse on repository with correct parameters',
        () async {
      when(mockCourseRepository.saveCourse(testCourse))
          .thenAnswer((_) async => testCourse);

      await saveCourseUseCase.execute(testCourse);

      verify(mockCourseRepository.saveCourse(testCourse));
      expect(saveCourseUseCase.execute(testCourse), completes);
    });
    test('should return the saved course from repository', () async {
      when(mockCourseRepository.saveCourse(testCourse))
          .thenAnswer((_) async => testCourse);

      final result = await saveCourseUseCase.execute(testCourse);

      expect(result, equals(testCourse));
    });

    test('should propagate exceptions from repository', () async {
      when(mockCourseRepository.saveCourse(testCourse))
          .thenThrow(Exception('Database error'));

      expect(() async => await saveCourseUseCase.execute(testCourse),
          throwsA(isA<Exception>()));
    });
  });
}
