import 'dart:convert';

import 'package:green_check/domain/models/answer.dart';

class SupabaseQuestion {
  final String id;
  final String titulo;
  final List<Answer> respuestas;

  SupabaseQuestion({
    required this.id,
    required this.titulo,
    required this.respuestas,
  });

  factory SupabaseQuestion.fromJson(Map<String, dynamic> json) {
    final rawRespuestas = json['respuestas'];
    final respuestasList =
        (rawRespuestas is String) ? jsonDecode(rawRespuestas) : rawRespuestas;

    return SupabaseQuestion(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      respuestas: (respuestasList as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'respuestas': respuestas.map((e) => e.toJson()).toList(),
    };
  }
}
