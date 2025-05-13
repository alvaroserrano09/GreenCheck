import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/entities/supabase_test.dart';
import 'package:green_check/infrastructure/mappers/test_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class TestService {
  Future<List<Test>> getTests(String idCourse) async {
    try {
      final response =
          await supabase.from('Test').select().eq("id_curso", idCourse);
      final List<Test> tests = response.map((testData) {
        return TestMapper.toDomain(
          SupabaseTest.fromJson(testData),
        );
      }).toList();

      return tests;
    } catch (e) {
      rethrow;
    }
  }

  Future<Test> saveTest(String title, String idCurso) async {
    try {
      final test = Test.create(title: title, courseId: idCurso);
      final response = await supabase
          .from('Test')
          .insert(TestMapper.toEntity(test))
          .select()
          .single();
      final testEntity = SupabaseTest.fromJson(response);
      final testDomain = TestMapper.toDomain(testEntity);
      return testDomain;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveQuestions(
      List<Question> questionsToSave, String testId) async {
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
    } catch (e) {
      rethrow;
    }
  }

  void deleteTest(String idTest, String idCourse) async {
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

  Future<List<Question>> getQuestions(String testId) async {
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
        );
      }).toList();

      return questions;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Test>> getTestsByIds(List<int> testIds) async {
    if (testIds.isEmpty) return [];

    try {
      final response =
          await supabase.from('Test').select().inFilter('id', testIds);
      final List<Test> tests = response.map((testData) {
        return TestMapper.toDomain(
          SupabaseTest.fromJson(testData),
        );
      }).toList();
      return tests;
    } catch (e) {
      throw Exception('Error al obtener los tests: ${e.toString()}');
    }
  }
}
