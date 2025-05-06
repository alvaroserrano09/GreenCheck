class Test {
  final int? id;
  final String title;
  final String courseId;

  Test({
    this.id,
    required this.title,
    required this.courseId,
  });

  factory Test.create({
    int? id,
    required String title,
    required String courseId,
  }) {
    return Test(
      id: id,
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

  Test copyWith({
    int? id,
    String? title,
    String? courseId,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
    );
  }
}
