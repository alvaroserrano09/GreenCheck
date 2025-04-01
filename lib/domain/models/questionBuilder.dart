import 'package:green_check/domain/models/question.dart';

class QuestionBuilder {
  final List<String> _lines = [];
  String? _generalFeedback;
  List<String> _tags = [];

  void addLine(String line) {
    if (line.startsWith('::')) {
      final nameMatch = RegExp(r'^::(.*?)::').firstMatch(line);
      if (nameMatch != null) {
        line = line.substring(nameMatch.end);
      }
    }

    final feedbackMatch = RegExp(r'####\s*(.*)$').firstMatch(line);
    if (feedbackMatch != null) {
      _generalFeedback = feedbackMatch.group(1)?.trim();
      line = line.substring(0, feedbackMatch.start).trim();
    }

    final tagsMatch = RegExp(r'\[([^\]]+)\]').firstMatch(line);
    if (tagsMatch != null) {
      _tags =
          tagsMatch.group(1)?.split(',').map((t) => t.trim()).toList() ?? [];
      line = line.substring(0, tagsMatch.start).trim();
    }

    _lines.add(line.trim());
  }

  Question? build() {
    final fullText = _lines.join('\n');
    if (fullText.isEmpty) return null;

    final braceStart = fullText.indexOf('{');
    final braceEnd = fullText.lastIndexOf('}');

    if (braceStart == -1 || braceEnd == -1) return null;

    final title = fullText.substring(0, braceStart).trim();
    final answersText = fullText.substring(braceStart + 1, braceEnd).trim();

    if (title.isEmpty) return null;

    final type = _determineQuestionType(title, answersText);
    final answers = _parseAnswers(answersText, type);

    return Question(
      title: title,
      answers: answers,
      correctAnswers:
          answers.where((o) => o.isCorrect).map((o) => o.text).toList(),
      questionType: type,
      feedback: _generalFeedback,
      tags: _tags,
    );
  }

  String _determineQuestionType(String title, String answersText) {
    if (answersText.contains('=')) {
      return 'multiple_choice';
    } else if (answersText.contains('~')) {
      return 'true_false';
    }
    return 'unknown';
  }

  List<Answer> _parseAnswers(String answersText, String type) {
    List<Answer> answers = [];
    final lines = answersText.split('\n');

    for (var line in lines) {
      if (line.startsWith('=')) {
        answers.add(Answer(text: line.substring(1).trim(), isCorrect: true));
      } else if (line.startsWith('~')) {
        answers.add(Answer(text: line.substring(1).trim(), isCorrect: false));
      }
    }
    return answers;
  }
}
