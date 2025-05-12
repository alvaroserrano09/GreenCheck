import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/domain/usecases/delete_course_use_case.dart';
import 'package:green_check/domain/usecases/delete_student_course_use_case.dart';
import 'package:green_check/domain/usecases/get_students_course_use_case.dart';
import 'package:green_check/domain/usecases/get_course_use_case.dart';
import 'package:green_check/domain/usecases/get_courses_student_use_case.dart';
import 'package:green_check/domain/usecases/get_courses_teacher_use_case.dart';
import 'package:green_check/domain/usecases/save_course_use_case.dart';
import 'package:green_check/domain/usecases/save_student_course.dart';
import 'package:green_check/domain/usecases/toggle_favorite_course_use_case.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_course_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/repositories/teacher_repository.dart';
import 'package:green_check/infrastructure/services/course_service.dart';
import 'package:green_check/infrastructure/services/student_course_service.dart';
import 'package:green_check/infrastructure/services/student_service.dart';
import 'package:green_check/infrastructure/services/teacher_service.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(CourseService());
});
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(StudentService());
});
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository(TeacherService());
});
final studentCourseRepositoryProvider =
    Provider<StudentCourseRepository>((ref) {
  return StudentCourseRepository(StudentCourseService());
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
  final studentCourseRepository = ref.watch(studentCourseRepositoryProvider);
  return GetCoursesStudentUseCase(
      studentCourseRepository,
      ref.watch(studentRepositoryProvider),
      ref.watch(teacherRepositoryProvider));
});

final getCourseStudentUseCaseProvider =
    Provider<GetCourseStudentUseCase>((ref) {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return GetCourseStudentUseCase(
      courseRepository, ref.watch(teacherRepositoryProvider));
});

final getStudentsUseCaseProvider = Provider<GetStudentsCourseUseCase>((ref) {
  final studentCourseRepository = ref.watch(studentCourseRepositoryProvider);
  return GetStudentsCourseUseCase(studentCourseRepository);
});
final saveStudentCourseUseCaseProvider =
    Provider<SaveStudentCourseUseCase>((ref) {
  final studentCourseRepository = ref.watch(studentCourseRepositoryProvider);
  final studentRepository = ref.watch(studentRepositoryProvider);
  return SaveStudentCourseUseCase(studentCourseRepository, studentRepository);
});

final deleteStudentCourseUseCaseProvider =
    Provider<DeleteStudentCourseUseCase>((ref) {
  final studentCourseRepository = ref.watch(studentCourseRepositoryProvider);
  return DeleteStudentCourseUseCase(studentCourseRepository);
});

final toggleFavoriteCourseUseCaseProvider =
    Provider<ToggleFavoriteCourseUseCase>((ref) {
  final studentCourseRepository = ref.watch(studentCourseRepositoryProvider);
  return ToggleFavoriteCourseUseCase(studentCourseRepository);
});
final deleteCourseUseCaseProvider = Provider<DeleteCourseUseCase>((ref) {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return DeleteCourseUseCase(courseRepository);
});

class CourseState {
  final bool isLoading;
  final String? errorMessage;
  final Course? course;
  final List<Course> courses;
  List<User> students;

  CourseState({
    required this.isLoading,
    this.errorMessage,
    this.course,
    this.courses = const [],
    this.students = const [],
  });

  CourseState copyWith({
    bool? isLoading,
    String? errorMessage,
    Course? course,
    List<Course>? courses,
    List<User>? students,
  }) {
    return CourseState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        course: course ?? this.course,
        courses: courses ?? this.courses,
        students: students ?? this.students);
  }

  factory CourseState.initial() => CourseState(isLoading: false);
}

class CourseNotifier extends StateNotifier<CourseState> {
  final SaveCourseUseCase saveCourseUseCase;
  final GetCoursesTeacherUseCase getCoursesTeacherUseCase;
  final GetCoursesStudentUseCase getCoursesStudentUseCase;
  final GetCourseStudentUseCase getCourseStudentUseCase;
  final GetStudentsCourseUseCase gestStudentsUseCase;
  final SaveStudentCourseUseCase saveStudentCourseUseCase;
  final DeleteStudentCourseUseCase deleteStudentCourseUseCase;
  final ToggleFavoriteCourseUseCase toggleFavoriteCourseUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;

  CourseNotifier(
    this.saveCourseUseCase,
    this.getCoursesTeacherUseCase,
    this.getCoursesStudentUseCase,
    this.getCourseStudentUseCase,
    this.gestStudentsUseCase,
    this.saveStudentCourseUseCase,
    this.deleteStudentCourseUseCase,
    this.toggleFavoriteCourseUseCase,
    this.deleteCourseUseCase,
  ) : super(CourseState.initial());

  Future<void> saveCourse({
    required String name,
    required String description,
    required String idTeacher,
    required String type,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final newCourse = Course.create(
        name: name,
        description: description,
        idTeacher: idTeacher,
        type: type,
        isFavorite: false,
      );

      final response = await saveCourseUseCase.execute(newCourse);
      state = state.copyWith(isLoading: false, course: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      throw Exception(e);
    }
  }

  Future<void> loadCoursesForTeacher(String idTeacher) async {
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

  Future<void> loadCoursesForStudent(String idTeacher) async {
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

  Future<void> loadCourse(String idCourse) async {
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

  Future<void> loadStudentsForCourse({required String idCourse}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final students = await gestStudentsUseCase.execute(idCourse);

      if (mounted) {
        state = state.copyWith(isLoading: false, students: students);
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

  Future<void> saveStudentCourse({
    required String idCourse,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final student = await saveStudentCourseUseCase.execute(idCourse, email);
      final updatedStudents = [...state.students, student];

      state = state.copyWith(
        isLoading: false,
        students: updatedStudents,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    }
  }

  Future<void> deleteStudent({
    required String idCourse,
    required String idStudent,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await deleteStudentCourseUseCase.execute(idStudent, idCourse);

      if (mounted) {
        final updatedStudents =
            state.students.where((student) => student.id != idStudent).toList();

        state = state.copyWith(
          isLoading: false,
          students: updatedStudents,
        );
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

  Future<void> toggleFavorite(String courseId, String idStudent) async {
    if (!mounted) return;

    try {
      final courses = [...state.courses];
      final index = courses.indexWhere((course) => course.id == courseId);
      if (index == -1) return;

      final currentCourse = courses[index];
      final newFavoriteStatus = !currentCourse.isFavorite;

      await toggleFavoriteCourseUseCase.execute(
        courseId,
        newFavoriteStatus,
        idStudent,
      );

      final updatedCourse = Course(
        id: currentCourse.id,
        name: currentCourse.name,
        isFavorite: newFavoriteStatus,
        description: currentCourse.description,
        idTeacher: currentCourse.idTeacher,
        type: currentCourse.type,
      );

      state = state.copyWith(
        courses: [...state.courses]..[index] = updatedCourse,
        errorMessage: null,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          errorMessage: "Error al actualizar favorito: ${e.toString()}",
        );
      }
      rethrow;
    }
  }

  Future<void> deleteCourse(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await deleteCourseUseCase.execute(id);

      final courses = [...state.courses];
      final index = courses.indexWhere((course) => course.id == id);

      if (index == -1) {
        state = state.copyWith(isLoading: false);
        return;
      }

      courses.removeAt(index);

      state = state.copyWith(
        isLoading: false,
        courses: courses,
        errorMessage: null,
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    } finally {
      return;
    }
  }
}

final courseProvider =
    StateNotifierProvider<CourseNotifier, CourseState>((ref) => CourseNotifier(
          ref.watch(saveCourseUseCaseProvider),
          ref.watch(getCoursesTeacherUseCaseProvider),
          ref.watch(getCoursesStudentUseCaseProvider),
          ref.watch(getCourseStudentUseCaseProvider),
          ref.watch(getStudentsUseCaseProvider),
          ref.watch(saveStudentCourseUseCaseProvider),
          ref.watch(deleteStudentCourseUseCaseProvider),
          ref.watch(toggleFavoriteCourseUseCaseProvider),
          ref.watch(deleteCourseUseCaseProvider),
        ));
