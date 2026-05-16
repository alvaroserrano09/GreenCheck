import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/providers/user_provider.dart';
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
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    Future.microtask(() {
      final studentState = ref.read(userProvider);
      final User? student = studentState.student;
      if (student != null) {
        if (student.role == 'alumno') {
          ref.read(courseProvider.notifier).loadCoursesForStudent(student.id);
        } else if (student.role == 'profesor') {
          ref.read(courseProvider.notifier).loadCoursesForTeacher(student.id);
        }
      }
    });
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, String courseId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar este curso? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(courseProvider.notifier).deleteCourse(courseId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Curso eliminado correctamente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseProvider);
    final studentState = ref.watch(userProvider);
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
                        rol: studentState.student?.role,
                        title: course.name,
                        teacher: course.teacherName != null
                            ? 'Profesor ${course.teacherName}'
                            : 'Profesor ${studentState.student?.name}',
                        onTap: () => context.push(
                            '/home/courses-screen/course-screen/${course.id}'),
                        isFavorite: course.isFavorite,
                        onPressed: () async {
                          if (studentState.student!.role == 'profesor') {
                            await _showDeleteConfirmation(context, course.id);
                          } else {
                            await ref
                                .read(courseProvider.notifier)
                                .toggleFavorite(
                                  course.id,
                                  studentState.student!.id,
                                );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: isProfessor
          ? FloatingActionButton(
              onPressed: () => context.push("/home/add-course-screen"),
              backgroundColor: const Color(0xFF8DC324),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const Toolbar(),
    );
  }
}
