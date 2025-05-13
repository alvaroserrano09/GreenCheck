import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/answer.dart';
import 'package:green_check/domain/models/result.dart';
import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/providers/results_provider.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/providers/test_provider.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';

class TestScreen extends ConsumerStatefulWidget {
  final String testId;
  static const String name = 'test-screen';

  const TestScreen({super.key, required this.testId});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  int _currentQuestionIndex = 0;

  final List<Answer?> _selectedAnswers = [];
  bool _testCompleted = false;
  int _score = 0;
  List<Question> _questions = [];
  late Test _test;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);

    try {
      final questions =
          await ref.read(testRepositoryProvider).getQuestions(widget.testId);
      final test =
          await ref.read(testRepositoryProvider).getTest(widget.testId);

      setState(() {
        _questions = questions;
        _isLoading = false;
        _test = test;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar las preguntas: $e")),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? _buildLoadingIndicator()
            : _testCompleted
                ? _buildResults(courseState.course!.id)
                : _buildQuestion(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Cargando preguntas..."),
        ],
      ),
    );
  }

  Widget _buildResults(String courseId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Test completado!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "Puntuación: $_score/${_questions.length}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 24),
          if (_isSaving)
            const CircularProgressIndicator()
          else
            CustomButton(
              text: "Ver revisión",
              onPressed: () {
                context.replace(
                  "/home/courses-screen/course-screen/${courseId}/tests-screen/test-screen/${widget.testId}/test-review",
                  extra: {
                    'questions': _questions,
                    'answers': _selectedAnswers,
                    'score': _score,
                  },
                );
              },
              backgroundColor: const Color(0xFF8DC324),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pregunta ${_currentQuestionIndex + 1} de ${_questions.length}",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          currentQuestion.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ...currentQuestion.answers.map((answer) => _buildAnswerButton(answer)),
        const Spacer(),
        if (_currentQuestionIndex > 0)
          CustomButton(
            text: "Anterior",
            onPressed: _goToPreviousQuestion,
            backgroundColor: Colors.grey,
          ),
        const SizedBox(height: 8),
        CustomButton(
          text: _currentQuestionIndex == _questions.length - 1
              ? "Finalizar Test"
              : "Siguiente",
          onPressed: _goToNextQuestion,
          backgroundColor: const Color(0xFF8DC324),
        ),
      ],
    );
  }

  Widget _buildAnswerButton(Answer answer) {
    final isSelected = _selectedAnswers.length > _currentQuestionIndex &&
        _selectedAnswers[_currentQuestionIndex] == answer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue[100] : Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onPressed: () => _selectAnswer(answer),
        child: Text(answer.text),
      ),
    );
  }

  void _selectAnswer(Answer answer) {
    setState(() {
      if (_selectedAnswers.length <= _currentQuestionIndex) {
        _selectedAnswers.add(answer);
      } else {
        _selectedAnswers[_currentQuestionIndex] = answer;
      }
    });
  }

  void _goToNextQuestion() {
    if (_selectedAnswers.length <= _currentQuestionIndex ||
        _selectedAnswers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor selecciona una respuesta")),
      );
      return;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      _calculateScore();
      _saveResults();
    }
  }

  void _goToPreviousQuestion() {
    setState(() => _currentQuestionIndex--);
  }

  void _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final selectedAnswer = _selectedAnswers[i];
      if (selectedAnswer != null && selectedAnswer.isCorrect) {
        score++;
      }
    }
    setState(() => _score = score);
  }

  Future<void> _saveResults() async {
    setState(() => _isSaving = true);

    try {
      final studentState = ref.read(studentProvider);
      final result = Result.create(
          idTest: widget.testId,
          score: _score,
          idStudent: studentState.student!.id,
          dateFinished: DateTime.now(),
          testName: _test.title);

      await ref.read(resultProvider.notifier).saveResult(result);

      setState(() => _testCompleted = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar resultados: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }
}
