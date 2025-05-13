import 'package:green_check/domain/models/result.dart';
import 'package:green_check/infrastructure/entities/supabase_result.dart';

class ResultMapper {
  static SupabaseResult toEntity(Result result) {
    return SupabaseResult(
      id: result.id,
      fechaRealizacion: result.dateFinished,
      puntuacion: result.score,
      idAlumno: result.idStudent,
      idTest: result.idTest,
    );
  }

  static Result toDomain(SupabaseResult result) {
    return Result(
      id: result.id,
      dateFinished: result.fechaRealizacion,
      score: result.puntuacion,
      idStudent: result.idAlumno,
      idTest: result.idTest,
    );
  }
}
