import 'package:green_check/domain/models/notices.dart';
import 'package:green_check/infrastructure/entities/supabase_notice.dart';

class NoticeMapper {
  static Notice toDomain(SupabaseNotice notice) {
    return Notice(
      id: notice.id,
      title: notice.titulo,
      message: notice.mensaje,
      idCourse: notice.idCurso,
    );
  }

  static SupabaseNotice toEntity(Notice notice) {
    return SupabaseNotice(
      id: notice.id,
      titulo: notice.title,
      mensaje: notice.message,
      idCurso: notice.idCourse,
    );
  }
}
