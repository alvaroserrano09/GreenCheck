import 'package:flutter/material.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class AddCourseScreen extends ConsumerStatefulWidget {
  static const String name = "add-course-screen";

  const AddCourseScreen({super.key});

  @override
  ConsumerState<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends ConsumerState<AddCourseScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController typeController;

  Map<String, String?> errorMessages = {'title': null, 'description': null};

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    typeController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    typeController.dispose();
    super.dispose();
  }

  void validateFields() {
    setState(() {
      errorMessages['title'] =
          titleController.text.isEmpty ? 'El titulo es obligatorio.' : null;
      errorMessages['type'] =
          typeController.text.isEmpty ? 'El tipo es obligatorio.' : null;
      errorMessages['description'] = descriptionController.text.isEmpty
          ? 'la descripción es obligatoria.'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);
    final User? student = studentState.student;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const BackGround(title: "Añadir Curso"),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 70),
                        const Text(
                          "Titulo",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CustomTextField(
                          labelText: 'Ingrese el título',
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
                        const SizedBox(height: 50),
                        const Text(
                          "Tipo",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CustomTextField(
                          labelText: 'Ingrese el tipo',
                          controller: typeController,
                        ),
                        if (errorMessages['type'] != null)
                          Text(
                            errorMessages['type']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 40),
                        const Text(
                          "Descripción",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Ingrese la descripción',
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
                        const Spacer(),
                        CustomButton(
                          text: "Añadir Curso",
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
                                  .read(courseProvider.notifier)
                                  .saveCourse(
                                    description: descriptionController.text,
                                    name: titleController.text,
                                    idTeacher: student.id!,
                                    type: typeController.text,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Curso añadido con éxito.'),
                                ),
                              );

                              titleController.clear();
                              descriptionController.clear();

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al crear el curso: $e'),
                                  backgroundColor: Colors.red, // Color de error
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
