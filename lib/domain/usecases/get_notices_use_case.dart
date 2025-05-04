import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/notices.dart';
import 'package:green_check/domain/usecases/get_courses_student_use_case.dart';
import 'package:green_check/domain/usecases/get_courses_teacher_use_case.dart';
import 'package:green_check/infrastructure/repositories/notice_repository.dart';

class GetNoticesUseCase {
  final NoticeRepository noticeRepository;
  final GetCoursesStudentUseCase getStudentCoursesUseCase;
  final GetCoursesTeacherUseCase getCoursesTeacherUseCase;

  GetNoticesUseCase({
    required this.noticeRepository,
    required this.getStudentCoursesUseCase,
    required this.getCoursesTeacherUseCase,
  });

  Future<List<Notice>> execute(String idStudent) async {
    List<Course> courses = await getStudentCoursesUseCase.execute(idStudent);
    if (courses.isEmpty) {
      courses = await getCoursesTeacherUseCase.execute(idStudent);
    }
    if (courses.isEmpty) {
      return [];
    }

    final List<int?> courseIds = courses.map((course) => course.id).toList();

    final notices = await noticeRepository.getNotices(courseIds);

    return notices;
  }
}
