import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/usecases/get_course_use_case.dart';
import 'package:green_check/domain/usecases/get_courses_student_use_case.dart';
import 'package:green_check/domain/usecases/get_courses_teacher_use_case.dart';
import 'package:green_check/domain/usecases/save_course_use_case.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:green_check/infrastructure/services/course_service.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(CourseService());
});

final saveCourseUseCaseProvider = Provider<SaveCourseUseCase>((ref) {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return SaveCourseUseCase(courseRepository);
});

final getCoursesTeacherUseCaseProvider =
    Provider<GetCoursesTeacherUseCase>((ref) {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return GetCoursesTeacherUseCase(courseRepository);
});

final getCoursesStudentUseCaseProvider =
    Provider<GetCoursesStudentUseCase>((ref) {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return GetCoursesStudentUseCase(courseRepository);
});

final getCourseStudentUseCaseProvider =
    Provider<GetCourseStudentUseCase>((ref) {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return GetCourseStudentUseCase(courseRepository);
});

class CourseState {
  final bool isLoading;
  final String? errorMessage;
  final Course? course;
  final List<Course> courses;

  CourseState({
    required this.isLoading,
    this.errorMessage,
    this.course,
    this.courses = const [],
  });

  CourseState copyWith({
    bool? isLoading,
    String? errorMessage,
    Course? course,
    List<Course>? courses,
  }) {
    return CourseState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      course: course ?? this.course,
      courses: courses ?? this.courses,
    );
  }

  factory CourseState.initial() => CourseState(isLoading: false);
}

class CourseNotifier extends StateNotifier<CourseState> {
  final SaveCourseUseCase saveCourseUseCase;
  final GetCoursesTeacherUseCase getCoursesTeacherUseCase;
  final GetCoursesStudentUseCase getCoursesStudentUseCase;
  final GetCourseStudentUseCase getCourseStudentUseCase;

  CourseNotifier(this.saveCourseUseCase, this.getCoursesTeacherUseCase,
      this.getCoursesStudentUseCase, this.getCourseStudentUseCase)
      : super(CourseState.initial());

  Future<void> saveCourse({
    required String name,
    required String description,
    required int idTeacher,
    required String type,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final newCourse = Course(
        name: name,
        description: description,
        idTeacher: idTeacher,
        type: type,
      );

      final response = await saveCourseUseCase.execute(newCourse);
      state = state.copyWith(isLoading: false, course: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }

  Future<void> loadCoursesForTeacher(int idTeacher) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final courses = await getCoursesTeacherUseCase.execute(idTeacher);

      if (mounted) {
        state = state.copyWith(isLoading: false, courses: courses);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    }
  }

  Future<void> loadCoursesForStudent(int idTeacher) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final courses = await getCoursesStudentUseCase.execute(idTeacher);

      if (mounted) {
        state = state.copyWith(isLoading: false, courses: courses);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    }
  }

  Future<void> loadCourse(int idCourse) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final course = await getCourseStudentUseCase.execute(idCourse);

      if (mounted) {
        state = state.copyWith(isLoading: false, course: course);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    }
  }
}

final courseProvider = StateNotifierProvider<CourseNotifier, CourseState>(
  (ref) => CourseNotifier(
    ref.watch(saveCourseUseCaseProvider),
    ref.watch(getCoursesTeacherUseCaseProvider),
    ref.watch(getCoursesStudentUseCaseProvider),
    ref.watch(getCourseStudentUseCaseProvider),
  ),
);
