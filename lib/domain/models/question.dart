import 'dart:convert';

import 'package:green_check/domain/models/answer.dart';
import 'package:uuid/uuid.dart';

class Question {
  final String id;
  final String title;
  final List<Answer> answers;
  final List<String>? correctAnswers;
  final String? feedback;

  Question({
    required this.id,
    required this.title,
    required this.answers,
    this.correctAnswers,
    this.feedback,
  });
  factory Question.create({
    required String title,
    required List<Answer> answers,
    List<String>? correctAnswers,
    String? feedback,
  }) {
    final id = const Uuid().v4();
    return Question(
      id: id,
      title: title,
      answers: answers,
      correctAnswers: correctAnswers,
      feedback: feedback,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['respuestas'];
    final answersList =
        (rawAnswers is String) ? jsonDecode(rawAnswers) : rawAnswers;

    return Question(
      id: json['id'] as String,
      title: json['pregunta'] as String,
      answers: (answersList as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctAnswers: List<String>.from(json['respuestas_correctas']),
      feedback: json['feedback_general'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pregunta': title,
      'respuestas': answers.map((a) => a.toJson()).toList(),
      'respuestas_correctas': correctAnswers,
      if (feedback != null) 'feedback_general': feedback,
    };
  }
}
