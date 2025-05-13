class SupabaseTest {
  String id;
  String idCurso;
  String titulo;

  SupabaseTest({
    required this.id,
    required this.idCurso,
    required this.titulo,
  });

  factory SupabaseTest.fromJson(Map<String, dynamic> json) {
    return SupabaseTest(
      id: json['id'] as String,
      idCurso: json['id_curso'] as String,
      titulo: json['titulo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_curso': idCurso,
      'titulo': titulo,
    };
  }
}
