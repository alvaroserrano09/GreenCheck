import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/notice.dart';
import 'package:green_check/domain/usecases/get_courses_student_use_case.dart';
import 'package:green_check/domain/usecases/get_courses_teacher_use_case.dart';
import 'package:green_check/domain/usecases/get_notices_use_case.dart';
import 'package:green_check/infrastructure/repositories/notice_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../mother/info_object_mother.dart';
import 'get_notices_use_case_test.mocks.dart';

@GenerateMocks([
  NoticeRepository,
  GetCoursesStudentUseCase,
  GetCoursesTeacherUseCase,
])
void main() {
  late GetNoticesUseCase getNoticesUseCase;
  late MockNoticeRepository mockNoticeRepository;
  late MockGetCoursesStudentUseCase mockGetStudentCoursesUseCase;
  late MockGetCoursesTeacherUseCase mockGetTeacherCoursesUseCase;

  const testStudentId = '3a376f1e-7968-4b8f-94b8-08defc1ba40d';

  setUp(() {
    mockNoticeRepository = MockNoticeRepository();
    mockGetStudentCoursesUseCase = MockGetCoursesStudentUseCase();
    mockGetTeacherCoursesUseCase = MockGetCoursesTeacherUseCase();

    getNoticesUseCase = GetNoticesUseCase(
      noticeRepository: mockNoticeRepository,
      getStudentCoursesUseCase: mockGetStudentCoursesUseCase,
      getCoursesTeacherUseCase: mockGetTeacherCoursesUseCase,
    );
  });

  group('GetNoticesUseCase', () {
    final List<Course> testStudentCourses = [
      InfoObjectMother.createCourse(),
      InfoObjectMother.createCourse2()
    ];

    final List<Course> testTeacherCourses = [
      InfoObjectMother.createCourse1(),
      InfoObjectMother.createCourse()
    ];

    final List<Notice> testNotices = [
      InfoObjectMother.createNotice(),
      InfoObjectMother.createNotice()
    ];

    test('should return notices for student courses', () async {
      when(mockGetStudentCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => testStudentCourses);
      when(mockGetTeacherCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => []);
      when(mockNoticeRepository.getNotices(any))
          .thenAnswer((_) async => testNotices);

      final result = await getNoticesUseCase.execute(testStudentId);

      verify(mockGetStudentCoursesUseCase.execute(testStudentId));
      verifyNever(mockGetTeacherCoursesUseCase.execute(testStudentId));
      verify(mockNoticeRepository.getNotices(any));

      expect(result.length, 2);
      expect(result, equals(testNotices));
    });

    test('should return notices for teacher courses when student has none',
        () async {
      when(mockGetStudentCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => []);
      when(mockGetTeacherCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => testTeacherCourses);
      when(mockNoticeRepository.getNotices(any))
          .thenAnswer((_) async => testNotices);

      final result = await getNoticesUseCase.execute(testStudentId);

      verify(mockGetStudentCoursesUseCase.execute(testStudentId));
      verify(mockGetTeacherCoursesUseCase.execute(testStudentId));
      verify(mockNoticeRepository.getNotices(any));

      expect(result.length, 2);
    });

    test('should return empty list when no courses found', () async {
      when(mockGetStudentCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => []);
      when(mockGetTeacherCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => []);

      final result = await getNoticesUseCase.execute(testStudentId);

      verify(mockGetStudentCoursesUseCase.execute(testStudentId));
      verify(mockGetTeacherCoursesUseCase.execute(testStudentId));
      verifyZeroInteractions(mockNoticeRepository);

      expect(result, isEmpty);
    });

    test('should return empty list when no notices found', () async {
      when(mockGetStudentCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => testStudentCourses);
      when(mockNoticeRepository.getNotices(any)).thenAnswer((_) async => []);

      final result = await getNoticesUseCase.execute(testStudentId);

      expect(result, isEmpty);
    });

    test('should rethrow exceptions from student courses use case', () async {
      when(mockGetStudentCoursesUseCase.execute(testStudentId))
          .thenThrow(Exception('Student courses error'));

      expect(
        () async => await getNoticesUseCase.execute(testStudentId),
        throwsA(isA<Exception>()),
      );
    });

    test('should rethrow exceptions from teacher courses use case', () async {
      when(mockGetStudentCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => []);
      when(mockGetTeacherCoursesUseCase.execute(testStudentId))
          .thenThrow(Exception('Teacher courses error'));

      expect(
        () async => await getNoticesUseCase.execute(testStudentId),
        throwsA(isA<Exception>()),
      );
    });

    test('should rethrow exceptions from notice repository', () async {
      when(mockGetStudentCoursesUseCase.execute(testStudentId))
          .thenAnswer((_) async => testStudentCourses);
      when(mockNoticeRepository.getNotices(any))
          .thenThrow(Exception('Notices error'));

      expect(
        () async => await getNoticesUseCase.execute(testStudentId),
        throwsA(isA<Exception>()),
      );
    });
  });
}
