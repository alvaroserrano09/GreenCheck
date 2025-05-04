import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class CourseScreen extends ConsumerStatefulWidget {
  static const String name = "course-screen";
  final int courseId;

  const CourseScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
  @override
  void initState() {
    super.initState();
    final studentState = ref.read(studentProvider);
    final User? student = studentState.student;
    Future.microtask(() {
      if (student != null) {
        ref.read(courseProvider.notifier).loadCourse(widget.courseId);
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
            const BackGround(title: "Detalles Curso"),
            if (courseState.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (!courseState.isLoading && courseState.course == null)
              const Center(child: Text('No se encontró el curso')),
            if (!courseState.isLoading && courseState.course != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        courseState.course!.name,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        "Profesor David caceres",
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xFF808080),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AutoSizeText(
                          courseState.course!.description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildClickableCard(
                        title: 'Tests',
                        onTap: () {
                          context.push(
                            "/home/courses-screen/course-screen/${courseState.course!.id}/tests-screen",
                            extra: {'courseId': courseState.course!.id},
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      if (isProfessor) ...[
                        _buildClickableCard(
                          title: 'Alumnos',
                          onTap: () {
                            context.push(
                                '/home/course-creen/students-screen/${courseState.course!.id}');
                          },
                        ),
                        const SizedBox(height: 80),
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }

  Widget _buildClickableCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFB2B2B2),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
