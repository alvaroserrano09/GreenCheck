import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class StudentsScreen extends ConsumerStatefulWidget {
  static const String name = 'students-screen';
  final int courseId;

  const StudentsScreen({super.key, required this.courseId});

  @override
  ConsumerState<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(courseProvider.notifier)
          .loadStudentsForCourse(idCourse: widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackGround(title: "Alumnos"),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 90.0, left: 20.0, right: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Gestiona los alumnos\n para tu curso',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 80),
                          if (courseState.isLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (courseState.errorMessage != null)
                            Text('Error: ${courseState.errorMessage}'),
                          if (courseState.students.isNotEmpty)
                            _buildStudentsList(
                                ref, courseState.students, widget.courseId)
                          else if (!courseState.isLoading &&
                              courseState.errorMessage == null)
                            const Center(
                              child: Text('No hay Alumnos'),
                            ),
                          _buildNewStudentForm(ref, widget.courseId),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStudentsList(WidgetRef ref, List<User> students, int courseId) {
  return ExpansionTile(
    title: const Text('Mis Alumnos',
        style: TextStyle(fontWeight: FontWeight.bold)),
    initiallyExpanded: true,
    children: students
        .map((student) => ListTile(
              trailing: IconButton(
                icon:
                    const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () async {
                  ref.read(courseProvider.notifier).deleteStudent(
                      idStudent: student.id!, idCourse: courseId);
                },
              ),
              title: Text('${student.name} ${student.surname}'),
              onTap: null,
            ))
        .toList(),
  );
}

Widget _buildNewStudentForm(WidgetRef ref, int courseId) {
  final TextEditingController emailController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Nuevo Alumno',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          labelText: 'Ingrese el email del usuario',
          controller: emailController,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: CustomButton(
            text: 'Añadir Alumno',
            onPressed: () async {
              ref.read(courseProvider.notifier).saveStudentCourse(
                  email: emailController.text, idCourse: courseId);
              emailController.clear();
            },
            backgroundColor: const Color(0xFF8DC324),
          ),
        ),
      ],
    ),
  );
}
