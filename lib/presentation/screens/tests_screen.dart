import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/providers/test_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class TestsScreen extends ConsumerStatefulWidget {
  static const String name = 'tests-screen';
  final String courseId;

  const TestsScreen({super.key, required this.courseId});

  @override
  ConsumerState<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends ConsumerState<TestsScreen> {
  final _titleController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(testProvider.notifier).getTests(idCourse: widget.courseId);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'doc', 'docx', 'jpg', 'png'],
        allowMultiple: false,
      );

      if (result != null) {
        if (result.files.first.size > 10 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('El archivo es demasiado grande (máximo 10MB)')),
          );
          return;
        }

        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } on PlatformException catch (e) {
      print("Error de plataforma al seleccionar archivo: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar archivo: ${e.message}')),
      );
    } catch (e) {
      print("Error al seleccionar archivo: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al seleccionar archivo: ${e.toString()}')),
      );
    }
  }

  Future<void> _submitNewTest() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un archivo')),
      );
      return;
    }

    try {
      await ref.read(testProvider.notifier).uploadTest(
            courseId: widget.courseId,
            title: _titleController.text,
            file: _selectedFile!,
          );

      _titleController.clear();
      setState(() => _selectedFile = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test creado exitosamente')),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(testProvider);
    final studentState = ref.watch(studentProvider);
    final bool isProfessor = studentState.student?.role == 'profesor';
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(title: 'Tests'),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 70.0, left: 16.0, right: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AutoSizeText(
                            "Tus tests \n en segundos",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          if (testState.isLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (testState.errorMessage != null)
                            Text('Error: ${testState.errorMessage}'),
                          if (testState.tests.isNotEmpty)
                            _buildTestsList(testState.tests, studentState)
                          else if (!testState.isLoading &&
                              testState.errorMessage == null)
                            const Center(
                              child: Text('No hay tests disponibles'),
                            ),
                          if (isProfessor) _buildNewTestForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewTestForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Nuevo Test',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Ingrese el titulo',
            controller: _titleController,
          ),
          const SizedBox(height: 16),
          _selectedFile != null
              ? Text('Archivo seleccionado: ${_selectedFile?.name}')
              : const Text('Ningún archivo seleccionado'),
          const SizedBox(height: 8),
          CustomButton(
            text: 'Seleccionar Archivo',
            onPressed: _pickFile,
            backgroundColor: const Color(0xFF76A8F2),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              text: 'Subir Test',
              onPressed: _submitNewTest,
              backgroundColor: const Color(0xFF8DC324),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestsList(List<Test> tests, dynamic studentState) {
    return ExpansionTile(
      title: const Text('Mis Tests',
          style: TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: true,
      children: tests.map((test) {
        return ListTile(
          leading: InkWell(
            borderRadius:
                BorderRadius.circular(24), // Radio del efecto de ripple
            onTap: () => _navigateToTest(test),
            child: IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.green),
              onPressed: () => _navigateToTest(test),
            ),
          ),
          trailing: studentState.student?.role == "profesor"
              ? IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  onPressed: () async {
                    ref.read(testProvider.notifier).deleteTest(
                        courseId: widget.courseId, testId: test.id!);
                  },
                )
              : null,
          title: InkWell(
            onTap: () => _navigateToTest(test),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 12), // Ajusta el padding para mejor tap
              child: Text(test.title),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _navigateToTest(Test test) {
    context.push(
        '/home/courses-screen/course-screen/${test.courseId}/tests-screen/test-screen/${test.id}');
  }
}
