class Question {
  final String title;
  final List<Answer> answers;
  final List<String> correctAnswers;
  final String? feedback;

  Question({
    required this.title,
    required this.answers,
    required this.correctAnswers,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'pregunta': title,
      'respuestas': answers.map((a) => a.toJson()).toList(),
      'respuestas_correctas': correctAnswers,
      if (feedback != null) 'feedback_general': feedback,
    };
  }
}

class Answer {
  final String text;
  final bool isCorrect;
  final String? feedback;

  Answer({
    required this.text,
    required this.isCorrect,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'texto': text,
      'correcta': isCorrect,
      if (feedback != null) 'feedback': feedback,
    };
  }
}
