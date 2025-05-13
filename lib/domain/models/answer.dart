class Answer {
  final String text;
  final bool isCorrect;
  final String? feedback;

  Answer({
    required this.text,
    required this.isCorrect,
    this.feedback,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['texto'] as String,
      isCorrect: json['correcta'] as bool,
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'texto': text,
      'correcta': isCorrect,
      if (feedback != null) 'feedback': feedback,
    };
  }
}
