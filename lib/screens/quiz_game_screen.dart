import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/settings_provider.dart';
import '../utils/translations.dart';

class QuizGameScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizGameScreen({super.key, required this.quiz});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;
  int? _selectedAnswerIndex;
  bool _showingDialog = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeShowResults();
  }

  void _checkAnswer(int selectedIndex) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _hasAnswered = true;
    });

    if (selectedIndex == widget.quiz.questions[_currentQuestionIndex].correctOptionIndex) {
      _score++;
    }
  }

  void _nextQuestion() {
    if (!_hasAnswered) return;

    setState(() {
      _currentQuestionIndex++;
      _hasAnswered = false;
      _selectedAnswerIndex = null;
    });

    _maybeShowResults();
  }

  void _maybeShowResults() {
    if (_currentQuestionIndex >= widget.quiz.questions.length && !_showingDialog) {
      _showingDialog = true;
      final language = context.read<SettingsProvider>().language;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(Translations.get('quizResults', language)),
            content: Text(
              '${Translations.get('score', language)}: $_score ${Translations.get('outOf', language)} ${widget.quiz.questions.length}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to quiz list
                },
                child: Text(Translations.get('done', language)),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;

    if (_currentQuestionIndex >= widget.quiz.questions.length) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
            ),
            const SizedBox(height: 16),
            Text(
              '${Translations.get('question', language)} ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${Translations.get('score', language)}: $_score',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...List.generate(
              question.options.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasAnswered
                        ? index == question.correctOptionIndex
                            ? Colors.green
                            : index == _selectedAnswerIndex
                                ? Colors.red
                                : null
                        : null,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    question.options[index],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (_hasAnswered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestionIndex < widget.quiz.questions.length - 1
                      ? Translations.get('nextQuestion', language)
                      : Translations.get('showResults', language),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 