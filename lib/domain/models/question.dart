class Question {
  final String title;
  final List<Answer> answers;
  final List<String> correctAnswers;
  final String questionType;
  final String? feedback;
  final List<String> tags;

  Question({
    required this.title,
    required this.answers,
    required this.correctAnswers,
    required this.questionType,
    this.feedback,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'pregunta': title,
      'tipo': questionType,
      'respuestas': answers.map((a) => a.toJson()).toList(),
      'respuestas_correctas': correctAnswers,
      if (feedback != null) 'feedback_general': feedback,
      if (tags.isNotEmpty) 'tags': tags,
    };
  }
}

class Answer {
  final String text;
  final bool isCorrect;
  final String? feedback;
  final double? numericalTolerance;
  final int? percentageCorrect;

  Answer({
    required this.text,
    required this.isCorrect,
    this.feedback,
    this.numericalTolerance,
    this.percentageCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'texto': text,
      'correcta': isCorrect,
      if (feedback != null) 'feedback': feedback,
      if (numericalTolerance != null) 'tolerancia': numericalTolerance,
      if (percentageCorrect != null) 'porcentaje': percentageCorrect,
    };
  }
}

class QuestionType {
  static const String trueFalse = 'true_false';
  static const String multipleChoice = 'multiple_choice';
  static const String fillBlank = 'fill_blank';
  static const String numerical = 'numerical';
  static const String matching = 'matching';
  static const String essay = 'essay';
  static const String mixed = 'mixed';
  static const String unknown = 'unknown';
}
