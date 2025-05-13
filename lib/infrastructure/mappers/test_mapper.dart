import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/entities/supabase_test.dart';

class TestMapper {
  static SupabaseTest toEntity(Test test) {
    return SupabaseTest(
      id: test.id,
      titulo: test.title,
      idCurso: test.courseId,
    );
  }

  static Test toDomain(SupabaseTest test) {
    return Test(
      id: test.id,
      title: test.titulo,
      courseId: test.idCurso,
    );
  }
}
