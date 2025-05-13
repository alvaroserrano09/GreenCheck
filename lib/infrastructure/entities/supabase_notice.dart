class SupabaseNotice {
  final String id;
  final String titulo;
  final String mensaje;
  final String idCurso;

  SupabaseNotice({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.idCurso,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'mensaje': mensaje,
      'id_curso': idCurso,
    };
  }

  factory SupabaseNotice.fromJson(Map<String, dynamic> json) {
    return SupabaseNotice(
      id: json['id'],
      titulo: json['titulo'],
      mensaje: json['mensaje'],
      idCurso: json['id_curso'],
    );
  }
}
