import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/providers/notice_provider.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class AddNoticeScreen extends ConsumerStatefulWidget {
  static const String name = "add-notice-screen";

  const AddNoticeScreen({super.key});

  @override
  ConsumerState<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends ConsumerState<AddNoticeScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String? selectedCourse; // Aquí es String? porque course.id es String
  bool _isLoadingCourses = false;

  Map<String, String?> errorMessages = {
    'title': null,
    'description': null,
    'course': null,
  };

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    Future.microtask(() => _loadTeacherCourses());
  }

  Future<void> _loadTeacherCourses() async {
    final student = ref.read(studentProvider).student;
    if (student != null && student.role == 'profesor') {
      setState(() => _isLoadingCourses = true);
      try {
        await ref
            .read(courseProvider.notifier)
            .loadCoursesForTeacher(student.id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar cursos: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoadingCourses = false);
        }
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void validateFields() {
    setState(() {
      errorMessages['title'] =
          titleController.text.isEmpty ? 'El título es obligatorio.' : null;
      errorMessages['course'] =
          selectedCourse == null ? 'El curso es obligatorio.' : null;
      errorMessages['description'] = descriptionController.text.isEmpty
          ? 'La descripción es obligatoria.'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);
    final User? student = studentState.student;
    final courseState = ref.watch(courseProvider);
    final courses = courseState.courses;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const BackGround(title: "Añadir Aviso"),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 70),
                        const Text(
                          "Título",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CustomTextField(
                          labelText: 'Ingrese el título del aviso',
                          controller: titleController,
                        ),
                        if (errorMessages['title'] != null)
                          Text(
                            errorMessages['title']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 20),
                        const Text(
                          "Aviso",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Ingrese el aviso',
                              filled: true,
                              fillColor: const Color(0xF4D9D9D9),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 16, left: 12, right: 12),
                            ),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            controller: descriptionController,
                          ),
                        ),
                        if (errorMessages['description'] != null)
                          Text(
                            errorMessages['description']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 20),
                        const Text(
                          "Curso",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _isLoadingCourses
                            ? const CircularProgressIndicator()
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButton<String?>(
                                  value: selectedCourse,
                                  hint: const Text("Selecciona un curso"),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCourse = newValue;
                                      errorMessages['course'] = null;
                                    });
                                  },
                                  items: courses.map<DropdownMenuItem<String?>>(
                                      (Course course) {
                                    return DropdownMenuItem<String?>(
                                      value: course.id,
                                      child: Text(course.name),
                                    );
                                  }).toList(),
                                ),
                              ),
                        if (errorMessages['course'] != null)
                          Text(
                            errorMessages['course']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        const Spacer(),
                        CustomButton(
                          text: "Añadir Aviso",
                          backgroundColor: const Color(0xFF8DC324),
                          onPressed: () async {
                            validateFields();
                            if (errorMessages.values
                                .any((message) => message != null)) {
                              return;
                            }

                            if (student == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'No se ha autenticado ningún profesor.'),
                                ),
                              );
                              return;
                            }

                            try {
                              await ref
                                  .read(noticeProvider.notifier)
                                  .saveNotice(
                                    description: descriptionController.text,
                                    name: titleController.text,
                                    courseId: selectedCourse!,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Aviso añadido con éxito.'),
                                ),
                              );

                              titleController.clear();
                              descriptionController.clear();
                              setState(() => selectedCourse = null);

                              if (mounted) {
                                context.go('/home/notices-screen');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al crear el Aviso: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
