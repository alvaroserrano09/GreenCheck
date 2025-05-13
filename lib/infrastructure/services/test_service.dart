import 'dart:convert';

import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/infrastructure/entities/supabase_question.dart';
import 'package:green_check/infrastructure/entities/supabase_test.dart';
import 'package:green_check/infrastructure/mappers/question_mapper.dart';
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
        final createdQuestion = Question.create(
          title: question.title,
          answers: question.answers,
          correctAnswers: question.correctAnswers,
          feedback: question.feedback,
        );

        final supabaseQuestion = QuestionMapper.toEntity(createdQuestion);
        final json = supabaseQuestion.toJson();

        return {
          'id': supabaseQuestion.id,
          'id_test': testId,
          'titulo': json['titulo'],
          'respuestas': jsonEncode(json['respuestas']),
        };
      }).toList();

      final response =
          await supabase.from('Preguntas').insert(questionsData).select();

      if (response.isEmpty) {
        throw Exception('No se guardaron las preguntas');
      }
    } catch (e) {
      print('Error al guardar las preguntas: $e');
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
      final response = await supabase
          .from('Preguntas')
          .select()
          .eq('id_test', testId) as List<dynamic>;

      final questions = response.map<Question>((questionData) {
        final supabaseQuestion = SupabaseQuestion.fromJson(questionData);
        return QuestionMapper.toDomain(supabaseQuestion);
      }).toList();

      return questions;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Test>> getTestsByIds(List<String> testIds) async {
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

  Future<Test> getTest(String testId) async {
    try {
      final response =
          await supabase.from('Test').select().eq('id', testId).maybeSingle();
      if (response == null || response.isEmpty) {
        throw Exception('Test no encontrado');
      }
      return TestMapper.toDomain(SupabaseTest.fromJson(response));
    } catch (e) {
      throw Exception('Error al obtener el test: ${e.toString()}');
    }
  }
}
