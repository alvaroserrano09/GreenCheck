import 'package:uuid/uuid.dart';

class Notice {
  final String id;
  final String title;
  final String message;
  final String idCourse;

  Notice({
    required this.id,
    required this.title,
    required this.message,
    required this.idCourse,
  });

  factory Notice.create({
    required String title,
    required String message,
    required String idCourse,
  }) {
    final id = const Uuid().v4();
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
