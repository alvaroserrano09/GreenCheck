import 'package:green_check/domain/models/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResultService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Result> saveResult(Result result) async {
    try {
      final response = await supabase
          .from('Resultado')
          .insert({
            'id_alumno': result.idStudent,
            'id_test': result.idTest,
            'puntuacion': result.score,
          })
          .select()
          .single();

      return Result(
        id: response['id'],
        idStudent: response['id_alumno'],
        idTest: response['id_test'],
        score: response['puntuacion'],
        dateFinished: DateTime.parse(response['fecha_realizacion']),
      );
    } catch (e) {
      print('Error saving result: $e');
      rethrow;
    }
  }
}
