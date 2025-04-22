import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class TestResult {
  final String testName;
  final String course;
  final String result;

  TestResult({
    required this.testName,
    required this.course,
    required this.result,
  });
}

class LastsResultsTestsScreen extends StatefulWidget {
  static const name = "lasts-results-tests-screen";

  const LastsResultsTestsScreen({super.key});

  @override
  State<LastsResultsTestsScreen> createState() =>
      _LastsResultsTestsScreenState();
}

class _LastsResultsTestsScreenState extends State<LastsResultsTestsScreen> {
  final List<TestResult> testResults = [
    TestResult(testName: "Test 1", course: "Acreditacion B1", result: "9/10"),
    TestResult(testName: "Test 1", course: "Acreditacion B1", result: "9/10"),
    TestResult(testName: "Test 1", course: "Acreditacion B1", result: "9/10"),
    TestResult(testName: "Test 1", course: "Acreditacion B1", result: "9/10"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(title: "Últimos Resultados"),
            Positioned.fill(
              top: 100,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: testResults.length,
                itemBuilder: (context, index) {
                  final result = testResults[index];
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
                              const Text(
                                "Resultado",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                result.result,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.testName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Curso: ${result.course}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: const Color(0xFFF2EFFF),
                            child: IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.green),
                              onPressed: () {
                                context.push(
                                    '/home/course-screen/tests-screen/test-screen/${39}');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
