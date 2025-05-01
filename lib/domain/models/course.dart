class Course {
  final int? id;
  final String name;
  final String description;
  final int idTeacher;
  final String? teacherName;
  final String type;
  final bool isFavorite;
  Course({
    this.id,
    required this.name,
    required this.description,
    required this.idTeacher,
    required this.type,
    this.teacherName,
    this.isFavorite = false,
  });

  factory Course.create({
    int? id,
    required String name,
    required String description,
    required int idTeacher,
    required String type,
    String? teacherName,
    required bool isFavorite,
  }) {
    return Course(
      id: id,
      name: name,
      description: description,
      idTeacher: idTeacher,
      type: type,
      teacherName: teacherName,
      isFavorite: isFavorite,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['nombre'],
      description: json['descripcion'],
      idTeacher: json['id_profesor'],
      type: json['tipo'],
      isFavorite: json['favorito'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'descripcion': description,
      'id_profesor': idTeacher,
      'tipo': type,
      'favorito': isFavorite,
    };
  }

  Course copyWith({
    int? id,
    String? name,
    String? description,
    int? idTeacher,
    String? type,
    String? teacherName,
    bool? isFavorite,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      idTeacher: idTeacher ?? this.idTeacher,
      type: type ?? this.type,
      teacherName: teacherName ?? this.teacherName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
