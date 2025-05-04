import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/notices.dart';
import 'package:green_check/domain/usecases/get_courses_student_use_case.dart';
import 'package:green_check/domain/usecases/get_courses_teacher_use_case.dart';
import 'package:green_check/domain/usecases/get_notices_use_case.dart';
import 'package:green_check/domain/usecases/save_notice_use_case.dart';
import 'package:green_check/infrastructure/repositories/course_repository.dart';
import 'package:green_check/infrastructure/repositories/notice_repository.dart';
import 'package:green_check/infrastructure/repositories/student_repository.dart';
import 'package:green_check/infrastructure/services/course_service.dart';
import 'package:green_check/infrastructure/services/notice_service.dart';
import 'package:green_check/infrastructure/services/student_service.dart';

final noticeRepositoryProvider = Provider<NoticeRepository>(
  (ref) {
    return NoticeRepository(NoticeService());
  },
);
final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) {
    return CourseRepository(CourseService());
  },
);
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(UserService());
});
final getStudentCoursesUseCaseProvider = Provider<GetCoursesStudentUseCase>(
  (ref) => GetCoursesStudentUseCase(
    ref.watch(courseRepositoryProvider),
    ref.watch(userRepositoryProvider),
  ),
);
final getCoursesTeacherUseCaseProvider = Provider<GetCoursesTeacherUseCase>(
  (ref) => GetCoursesTeacherUseCase(ref.watch(courseRepositoryProvider)),
);
final getNoticesProvider = Provider<GetNoticesUseCase>(
  (ref) {
    final noticeRepository = ref.watch(noticeRepositoryProvider);
    return GetNoticesUseCase(
      noticeRepository: noticeRepository,
      getStudentCoursesUseCase: ref.watch(getStudentCoursesUseCaseProvider),
      getCoursesTeacherUseCase: ref.watch(getCoursesTeacherUseCaseProvider),
    );
  },
);
final saveNoticeProvider = Provider<SaveNoticeUseCase>(
  (ref) {
    final noticeRepository = ref.watch(noticeRepositoryProvider);
    return SaveNoticeUseCase(noticeRepository);
  },
);
final noticeProvider = StateNotifierProvider<NoticeNotifier, NoticeState>(
  (ref) => NoticeNotifier(
      ref.watch(getNoticesProvider), ref.watch(saveNoticeProvider)),
);

class NoticeState {
  final bool isLoading;
  final String? errorMessage;
  final List<Notice>? notices;

  NoticeState({
    required this.isLoading,
    this.errorMessage,
    this.notices,
  });

  NoticeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Notice>? notices,
  }) {
    return NoticeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      notices: notices ?? this.notices,
    );
  }

  factory NoticeState.initial() => NoticeState(isLoading: false);
}

class NoticeNotifier extends StateNotifier<NoticeState> {
  final GetNoticesUseCase getNotices;
  final SaveNoticeUseCase saveNoticeUseCase;
  NoticeNotifier(this.getNotices, this.saveNoticeUseCase)
      : super(NoticeState.initial());

  Future<void> fetchNotices(String idStudent) async {
    state = state.copyWith(isLoading: true);
    try {
      final notices = await getNotices.execute(idStudent);
      state = state.copyWith(isLoading: false, notices: notices);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  saveNotice(
      {required String description,
      required String name,
      required int courseId}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final notice = Notice(
        message: description,
        title: name,
        idCourse: courseId,
      );
      final newNotice = await saveNoticeUseCase.execute(notice);
      state = state.copyWith(
        isLoading: false,
        notices: [...state.notices!, newNotice],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
