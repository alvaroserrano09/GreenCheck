import 'package:green_check/domain/models/notices.dart';
import 'package:green_check/infrastructure/repositories/notice_repository.dart';

class SaveNoticeUseCase {
  final NoticeRepository noticeRepository;

  SaveNoticeUseCase(this.noticeRepository);

  Future<Notice> execute(Notice notice) async {
    try {
      final newNotice = noticeRepository.saveNotice(notice);
      return newNotice;
    } catch (e) {
      throw Exception('Failed to save notice: $e');
    }
  }
}
