import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/usecases/get_courses_student_use_case.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'get_courses_student_use_case_test.mocks.dart';

@GenerateMocks([
  StudentCourseRepository,
  StudentRepository,
  TeacherRepository,
])
void main() {
  late GetCoursesStudentUseCase getCoursesStudentUseCase;
  late MockStudentCourseRepository mockStudentCourseRepository;
  late MockStudentRepository mockStudentRepository;
  late MockTeacherRepository mockTeacherRepository;

  const testStudentId = '3a376f1e-7968-4b8f-94b8-08defc1ba40d';
  const testTeacherId = '61ea020f-5851-48c0-b9b0-6b2680853f7d';

  setUp(() {
    mockStudentCourseRepository = MockStudentCourseRepository();
    mockStudentRepository = MockStudentRepository();
    mockTeacherRepository = MockTeacherRepository();

    getCoursesStudentUseCase = GetCoursesStudentUseCase(
      mockStudentCourseRepository,
      mockStudentRepository,
      mockTeacherRepository,
    );
  });

  group('GetCoursesStudentUseCase', () {
    final List<Course> testCourses = [
      InfoObjectMother.createCourse(),
      InfoObjectMother.createCourse2(),
    ];

    final testTeacher = InfoObjectMother.createTeacher();

    test('should get courses with teacher names', () async {
      when(mockStudentCourseRepository.getCoursesForStudent(testStudentId))
          .thenAnswer((_) async => testCourses);

      when(mockTeacherRepository.getTeacherById(testTeacherId))
          .thenAnswer((_) async => testTeacher);

      when(mockTeacherRepository.getTeacherById(testTeacherId))
          .thenAnswer((_) async => testTeacher);

      final result = await getCoursesStudentUseCase.execute(testStudentId);

      verify(mockStudentCourseRepository.getCoursesForStudent(testStudentId));
      verify(mockTeacherRepository.getTeacherById(testTeacherId));

      expect(result.length, 2);
      expect(result[0].teacherName, 'Álvaro');
      expect(result[1].teacherName, 'Álvaro');
    });

    test('should handle empty course list', () async {
      when(mockStudentCourseRepository.getCoursesForStudent(testStudentId))
          .thenAnswer((_) async => []);

      final result = await getCoursesStudentUseCase.execute(testStudentId);

      verify(mockStudentCourseRepository.getCoursesForStudent(testStudentId));

      expect(result, isEmpty);
    });

    test('should handle null teacher response', () async {
      when(mockStudentCourseRepository.getCoursesForStudent(testStudentId))
          .thenAnswer((_) async => testCourses);

      when(mockTeacherRepository.getTeacherById(any))
          .thenAnswer((_) async => null);

      final result = await getCoursesStudentUseCase.execute(testStudentId);

      expect(result.length, 2);
      expect(result[0].teacherName, isNull);
      expect(result[1].teacherName, isNull);
    });

    test('should throw exception when course fetch fails', () async {
      when(mockStudentCourseRepository.getCoursesForStudent(testStudentId))
          .thenThrow(Exception('Course fetch failed'));

      expect(
        () async => await getCoursesStudentUseCase.execute(testStudentId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'exception message',
          contains('Error al obtener cursos'),
        )),
      );
    });

    test('should throw exception when teacher fetch fails', () async {
      when(mockStudentCourseRepository.getCoursesForStudent(testStudentId))
          .thenAnswer((_) async => testCourses);

      when(mockTeacherRepository.getTeacherById(any))
          .thenThrow(Exception('Teacher fetch failed'));

      expect(
        () async => await getCoursesStudentUseCase.execute(testStudentId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'exception message',
          contains('Error al obtener cursos'),
        )),
      );
    });
  });
}
