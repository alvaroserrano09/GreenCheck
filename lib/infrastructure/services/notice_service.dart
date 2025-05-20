import 'package:green_check/domain/models/notice.dart';
import 'package:green_check/infrastructure/entities/supabase_notice.dart';
import 'package:green_check/infrastructure/mappers/notice_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoticeService {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<List<Notice>> getNotices(List<String?> courseIds) async {
    final filteredCourseIds = courseIds.whereType<String>().toList();
    if (filteredCourseIds.isEmpty) return [];

    try {
      final orFilter =
          filteredCourseIds.map((id) => 'id_curso.eq.$id').join(',');

      final response = await supabase.from('Aviso').select().or(orFilter);

      return response
          .map((data) => SupabaseNotice.fromJson(data))
          .map(NoticeMapper.toDomain)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Notice> saveNotice(Notice notice) {
    return supabase
        .from('Aviso')
        .insert(NoticeMapper.toEntity(notice).toJson())
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
