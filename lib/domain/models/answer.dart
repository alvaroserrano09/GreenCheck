class Answer {
  final String text;
  final bool isCorrect;

  Answer({
    required this.text,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['texto'] as String,
      isCorrect: json['correcta'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'texto': text,
      'correcta': isCorrect,
    };
  }
}
