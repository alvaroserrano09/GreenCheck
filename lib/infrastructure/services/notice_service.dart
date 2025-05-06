import 'package:green_check/domain/models/notices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoticeService {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<List<Notice>> getNotices(List<String?> courseIds) async {
    if (courseIds.isEmpty) {
      return [];
    }

    final response = await supabase
        .from('Aviso')
        .select()
        .or(courseIds.map((id) => 'id_curso.eq.$id').join(','));

    return (response as List).map((noticeData) {
      return Notice(
        id: noticeData['id'],
        title: noticeData['titulo'],
        message: noticeData['mensaje'],
        idCourse: noticeData['id_curso'],
      );
    }).toList();
  }

  Future<Notice> saveNotice(Notice notice) {
    return supabase
        .from('Aviso')
        .insert({
          'titulo': notice.title,
          'mensaje': notice.message,
          'id_curso': notice.idCourse,
        })
        .select()
        .single()
        .then((response) {
          return Notice(
            id: response['id'],
            title: response['titulo'],
            message: response['mensaje'],
            idCourse: response['id_curso'],
          );
        });
  }
}
