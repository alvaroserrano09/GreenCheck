import 'package:green_check/domain/models/notices.dart';
import 'package:green_check/infrastructure/services/notice_service.dart';

class NoticeRepository {
  final NoticeService datasource;
  NoticeRepository(this.datasource);

  Future<List<Notice>> getNotices(List<int?> ids) {
    return datasource.getNotices(ids);
  }

  Future<Notice> saveNotice(Notice notice) {
    return datasource.saveNotice(notice);
  }
}
