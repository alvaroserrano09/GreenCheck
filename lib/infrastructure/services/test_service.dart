import 'package:green_check/domain/models/question.dart';
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

  Future<Test> saveTest(String title, int idCurso) async {
    try {
      final response = await supabase
          .from('Test')
          .insert({'titulo': title, 'id_curso': idCurso})
          .select()
          .single();
      return Test(
        courseId: response['id_curso'],
        title: response['titulo'],
        id: response['id'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveQuestions(List<Question> questionsToSave, int testId) async {
    try {
      final List<Map<String, dynamic>> questionsData =
          questionsToSave.map((question) {
        return {
          'id_test': testId,
          'titulo': question.title,
          'respuestas': {
            'respuestas': question.answers
                .map((option) => {
                      'respuesta': option.text,
                      'correcta': option.isCorrect,
                      if (option.feedback != null) 'feedback': option.feedback,
                    })
                .toList(),
            'respuestas_correctas': question.correctAnswers,
          }
        };
      }).toList();

      final response =
          await supabase.from('Preguntas').insert(questionsData).select();

      if (response.isEmpty) {
        throw Exception('No se guardaron las preguntas');
      }

      print('✅ Preguntas guardadas: ${response.length}');
    } catch (e) {
      print('❌ Error al guardar preguntas: $e');
      rethrow;
    }
  }

  void deleteTest(int idTest, int idCourse) async {
    try {
      await supabase
          .from('Test')
          .delete()
          .eq('id', idTest)
          .eq('id_curso', idCourse);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Question>> getQuestions(int testId) async {
    try {
      final response =
          await supabase.from('Preguntas').select().eq('id_test', testId);

      final List<Question> questions = response.map<Question>((questionData) {
        final List<dynamic> answersData =
            questionData['respuestas']['respuestas'] ?? [];

        final List<Answer> answers = answersData.map<Answer>((answerData) {
          return Answer(
            text: answerData['respuesta'] as String,
            isCorrect: answerData['correcta'] as bool,
            feedback: answerData['feedback'] as String?,
          );
        }).toList();

        final List<String> correctAnswers = (questionData['respuestas']
                    ['respuestas_correctas'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        return Question(
          title: questionData['titulo'] as String,
          answers: answers,
          correctAnswers: correctAnswers,
          questionType: 'Test',
        );
      }).toList();

      return questions;
    } catch (e) {
      rethrow;
    }
  }
}
