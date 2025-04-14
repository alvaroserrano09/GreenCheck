import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/providers/notice_provider.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class NoticesScreen extends ConsumerStatefulWidget {
  static const String name = 'notices-screen';
  const NoticesScreen({
    super.key,
  });

  @override
  ConsumerState<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends ConsumerState<NoticesScreen> {
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadNotices());
  }

  Future<void> _loadNotices() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    try {
      final student = ref.read(studentProvider).student;

      await ref.read(noticeProvider.notifier).fetchNotices(student?.id ?? 0);
      if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error al cargar los avisos';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);
    final student = studentState.student;
    final role = student?.role;
    final isTeacher = role == 'profesor';

    final noticesState = ref.watch(noticeProvider);
    final notices = noticesState.notices ?? [];

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
                child: RefreshIndicator(
                  onRefresh: _loadNotices,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      final notice = notices[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: _buildNoticeCard(
                            heading: notice.title,
                            title: notice.title,
                            content: notice.message),
                      );
                    },
                  ),
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
                    onPressed: () =>
                        context.push("/home/notices-screen/add-notice-screen"),
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
