import 'package:uuid/uuid.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final String idTeacher;
  final String? teacherName;
  final String type;
  final bool isFavorite;
  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.idTeacher,
    required this.type,
    this.teacherName,
    this.isFavorite = false,
  });

  factory Course.create({
    required String name,
    required String description,
    required String idTeacher,
    required String type,
    String? teacherName,
    required bool isFavorite,
  }) {
    final uuid = const Uuid().v4();
    return Course(
      id: uuid,
      name: name,
      description: description,
      idTeacher: idTeacher,
      type: type,
      teacherName: teacherName,
      isFavorite: isFavorite,
    );
  }
}
