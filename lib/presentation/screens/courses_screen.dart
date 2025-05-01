import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/course_card.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  static const String name = "courses-screen";

  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CoursesScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final studentState = ref.read(studentProvider);
      final User? student = studentState.student;
      if (student != null && student.id != null) {
        if (student.role == 'alumno') {
          ref.read(courseProvider.notifier).loadCoursesForStudent(student.id!);
        } else if (student.role == 'profesor') {
          ref.read(courseProvider.notifier).loadCoursesForTeacher(student.id!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseProvider);
    final studentState = ref.watch(studentProvider);

    final bool isProfessor = studentState.student?.role == 'profesor';
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(title: "Mis Cursos"),
            if (courseState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (courseState.errorMessage != null)
              Center(
                child: Text(
                  'Error: ${courseState.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (courseState.courses.isEmpty)
              const Center(child: Text('No hay cursos disponibles.'))
            else
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: courseState.courses.length,
                  itemBuilder: (context, index) {
                    final course = courseState.courses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: CourseCard(
                        title: course.name,
                        teacher: course.teacherName != null
                            ? 'Profesor ${course.teacherName}'
                            : 'Profesor ${studentState.student?.name} ',
                        onTap: () =>
                            context.push('/home/course-screen/${course.id}'),
                      ),
                    );
                  },
                ),
              ),
            if (isProfessor)
              Positioned(
                bottom: 16,
                right: 16,
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: FloatingActionButton(
                    onPressed: () {
                      context.push("/home/add-course-screen");
                    },
                    backgroundColor: const Color(0xFF8DC324),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
