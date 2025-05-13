import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/result.dart';
import 'package:green_check/presentation/providers/results_provider.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class LastsResultsTestsScreen extends ConsumerStatefulWidget {
  static const name = "lasts-results-tests-screen";

  const LastsResultsTestsScreen({super.key});

  @override
  ConsumerState<LastsResultsTestsScreen> createState() =>
      _LastsResultsTestsScreenState();
}

class _LastsResultsTestsScreenState
    extends ConsumerState<LastsResultsTestsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final studentState = ref.read(studentProvider);
      if (studentState.student?.id != null) {
        ref
            .read(resultProvider.notifier)
            .getLastResults(studentState.student!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsState = ref.watch(resultProvider);

    if (resultsState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final results = resultsState.results ?? [];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(title: "Últimos Resultados"),
            Positioned.fill(
              top: 60,
              child: _buildResultsList(results),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }

  Widget _buildResultsList(List<Result> results) {
    if (results.isEmpty) {
      return const Center(child: Text('No hay resultados disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Resultado",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text("${result.score}/20",
                        style: const TextStyle(fontSize: 16)),
                    Text(
                      "Fecha: ${result.dateFinished.day}/${result.dateFinished.month}/${result.dateFinished.year}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.testName ?? 'Nombre no disponible',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: const Color(0xFFF2EFFF),
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                    onPressed: () => context.push(
                      '/home/results-screen/test-screen/${result.idTest}',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
