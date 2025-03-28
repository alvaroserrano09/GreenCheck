import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/providers/test_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class TestsScreen extends ConsumerStatefulWidget {
  static const String name = 'tests-screen';
  final int courseId;

  const TestsScreen({super.key, required this.courseId});

  @override
  ConsumerState<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends ConsumerState<TestsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _selectedFilePath;

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
    setState(() => _selectedFilePath = '/ruta/del/archivo.pdf');
  }

  void _submitNewTest() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFilePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor selecciona un archivo')));
        return;
      }

      // Aquí llamarías a tu provider para subir el test
      // Ejemplo:
      // ref.read(testProvider.notifier).uploadTest(
      //   courseId: widget.courseId,
      //   title: _titleController.text,
      //   filePath: _selectedFilePath!,
      // );

      // Limpiar el formulario
      _titleController.clear();
      setState(() {
        _selectedFilePath = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test creado exitosamente')));
    }
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
                            _buildTestsList(testState.tests)
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
          CustomTextField(labelText: 'Ingrese el titulo'),
          const SizedBox(height: 16),
          _selectedFilePath != null
              ? Text(
                  'Archivo seleccionado: ${_selectedFilePath!.split('/').last}')
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

  Widget _buildTestsList(List<Test> tests) {
    return ExpansionTile(
      title: const Text('Mis Tests',
          style: TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: true,
      children: tests
          .map((test) => ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.green),
                title: Text(test.title),
                onTap: () {},
              ))
          .toList(),
    );
  }
}
