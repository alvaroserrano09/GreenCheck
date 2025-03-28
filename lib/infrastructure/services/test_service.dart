import 'package:green_check/domain/models/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class TestService {
  Future<List<Test>> getTests(int idCourse) async {
    try {
      final response =
          await supabase.from('Test').select().eq("id_curso", idCourse);
      final List<Test> tests = response.map((testData) {
        return Test(
            courseId: testData['id_curso'],
            title: testData['titulo'],
            id: testData['id']);
      }).toList();

      return tests;
    } catch (e) {
      rethrow;
    }
  }
}
