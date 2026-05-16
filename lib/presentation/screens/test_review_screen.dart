import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/answer.dart';
import 'package:green_check/domain/models/question.dart';
import 'package:green_check/presentation/widgets/background.dart';

class TestReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final List<Answer?> selectedAnswers;
  final int score;

  static const String name = 'test-review-screen';

  const TestReviewScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(
              title: 'Revisión del Test',
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 90,
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewPadding.bottom + 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Test completado!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "PUNTUACIÓN $score/${questions.length}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(
                        questions.length,
                        (index) => _buildQuestionItem(index),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8DC324),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.go('/home/courses-screen');
                          },
                          child: const Text(
                            'Finalizar Revisión',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionItem(int index) {
    final question = questions[index];
    final selected = selectedAnswers[index];
    final isCorrect = selected?.isCorrect ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green[100] : Colors.red[100], // <-- AQUÍ
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pregunta ${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(question.title, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  isCorrect ? "Correcta" : "Incorrecta",
                  style: TextStyle(
                    color: isCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...question.answers.map((answer) => _buildAnswer(answer, selected)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAnswer(Answer answer, Answer? selected) {
    final bool isSelected = selected == answer;
    final bool isAnswerCorrect = answer.isCorrect;

    Color? bgColor;
    Icon? icon;

    if (isAnswerCorrect) {
      bgColor = Colors.green[50];
      if (isSelected) {
        icon = const Icon(Icons.check, color: Colors.green);
      }
    } else if (isSelected && !isAnswerCorrect) {
      bgColor = Colors.red[50];
      icon = const Icon(Icons.close, color: Colors.red);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(answer.text)),
          if (icon != null) icon,
        ],
      ),
    );
  }
}
