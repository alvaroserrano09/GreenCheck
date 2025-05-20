import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/question_builder.dart';

class TestParser {
  List<Question> parse(String content) {
    final questions = <Question>[];
    final lines = content.replaceAll('\r\n', '\n').split('\n');
    var currentQuestion = QuestionBuilder();
    var inQuestionBlock = false;
    var inBraces = false;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('//')) continue;

      if (line.startsWith('::') || (!inQuestionBlock && line.contains('{'))) {
        if (inQuestionBlock) {
          final question = currentQuestion.build();
          if (question != null) questions.add(question);
          currentQuestion = QuestionBuilder();
        }
        inQuestionBlock = true;
      }

      if (inQuestionBlock) {
        currentQuestion.addLine(line);
        if (line.contains('{')) inBraces = true;
        if (line.contains('}')) inBraces = false;

        if (!inBraces && (line.endsWith('}') || lines.last == line)) {
          final question = currentQuestion.build();
          if (question != null) questions.add(question);
          currentQuestion = QuestionBuilder();
          inQuestionBlock = false;
        }
      }
    }

    if (inQuestionBlock) {
      final question = currentQuestion.build();
      if (question != null) questions.add(question);
    }

    return questions;
  }
}
