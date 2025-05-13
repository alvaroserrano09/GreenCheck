import 'package:uuid/uuid.dart';

class Test {
  final String id;
  final String title;
  final String courseId;

  Test({
    required this.id,
    required this.title,
    required this.courseId,
  });

  factory Test.create({
    required String title,
    required String courseId,
  }) {
    final uuid = const Uuid().v4();
    return Test(
      id: uuid,
      title: title,
      courseId: courseId,
    );
  }

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      title: json['titulo'] ?? json['title'],
      courseId: json['id_curso'] ?? json['courseId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': title,
      'id_curso': courseId,
    };
  }
}
