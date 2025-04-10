import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class NoticesScreen extends ConsumerStatefulWidget {
  static const String name = 'notices-screen';
  const NoticesScreen({super.key});

  @override
  ConsumerState<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends ConsumerState<NoticesScreen> {
  final List<Map<String, String>> notices = [
    {
      'heading': 'Corrección de errores test 2',
      'title': 'Curso: Acreditación B1',
      'content':
          'He realizado algunos cambios en el test 2 ya que contenía algunos errores de redacción',
    },
    {
      'heading': 'Nuevos Tests!!',
      'title': 'Curso: Oposiciones Bombero',
      'content':
          'Añadidos nuevos tests respecto al cambio de temario producido en la última reunión',
    },
  ];

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar los avisos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);
    final student = studentState.student;

    final role = student?.role;

    final isTeacher = role == 'profesor';
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(title: 'Avisos'),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage != null)
              Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (notices.isEmpty)
              const Center(child: Text('No hay avisos disponibles.'))
            else
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: _buildNoticeCard(
                        heading: notice['heading']!,
                        title: notice['title']!,
                        content: notice['content']!,
                      ),
                    );
                  },
                ),
              ),
            if (isTeacher)
              Positioned(
                bottom: 16,
                right: 16,
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: FloatingActionButton(
                    onPressed: () => context.push("/home/add-notice-screen"),
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

  Widget _buildNoticeCard({
    required String heading,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
