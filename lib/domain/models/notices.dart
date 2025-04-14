class Notice {
  final int? id;
  final String title;
  final String message;
  final int idCourse;

  Notice({
    this.id,
    required this.title,
    required this.message,
    required this.idCourse,
  });

  factory Notice.create({
    int? id,
    required String title,
    required String message,
    required int idCourse,
  }) {
    return Notice(
      id: id,
      title: title,
      message: message,
      idCourse: idCourse,
    );
  }

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      title: json['titulo'],
      message: json['mensaje'],
      idCourse: json['id_curso'],
    );
  }
}
