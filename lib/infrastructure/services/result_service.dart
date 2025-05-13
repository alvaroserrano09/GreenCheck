import 'package:green_check/domain/models/result.dart';
import 'package:green_check/infrastructure/mappers/result_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResultService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Result> saveResult(Result result) async {
    try {
      final response = await supabase
          .from('Resultado')
          .insert(ResultMapper.toEntity(result).toJson())
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
      rethrow;
    }
  }

  Future<List<Result>> getResultsByStudentId(String studentId) async {
    try {
      final response = await supabase
          .from('Resultado')
          .select()
          .eq('id_alumno', studentId)
          .order('fecha_realizacion', ascending: false);

      return (response as List).map((json) => Result.fromJson(json)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
