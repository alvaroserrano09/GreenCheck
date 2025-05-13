import 'package:green_check/domain/models/question.dart';
import 'package:green_check/infrastructure/entities/supabase_question.dart';

class QuestionMapper {
  static SupabaseQuestion toEntity(Question question) {
    return SupabaseQuestion(
      id: question.id,
      titulo: question.title,
      respuestas: question.answers,
    );
  }

  static Question toDomain(SupabaseQuestion question) {
    return Question(
      id: question.id,
      title: question.titulo,
      answers: question.respuestas,
    );
  }
}
