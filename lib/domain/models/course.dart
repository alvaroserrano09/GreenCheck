class Course {
  final int? id;
  final String name;
  final String description;
  final int idTeacher;
  final String? teacherName;
  final String type;

  Course({
    this.id,
    required this.name,
    required this.description,
    required this.idTeacher,
    required this.type,
    this.teacherName,
  });

  factory Course.create({
    int? id,
    required String name,
    required String description,
    required DateTime createdAt,
    required int idTeacher,
    required String type,
    String? teacherName,
  }) {
    return Course(
      id: id,
      name: name,
      description: description,
      idTeacher: idTeacher,
      type: type,
      teacherName: teacherName,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['nombre'],
      description: json['descripcion'],
      idTeacher: json['id_profesor'],
      type: json['tipo'],
    );
  }
}
