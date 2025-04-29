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

  void _checkAnswer(int selectedIndex) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _hasAnswered = true;
      if (selectedIndex == widget.quiz.questions[_currentQuestionIndex].correctOptionIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (!_hasAnswered) return;

    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _hasAnswered = false;
        _selectedAnswerIndex = null;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final language = context.read<SettingsProvider>().language;
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
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(Translations.get('done', language)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;
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
            const SizedBox(height: 24),
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedAnswerIndex == index;
                  final isCorrect = _hasAnswered && index == question.correctOptionIndex;
                  final isWrong = _hasAnswered && isSelected && !isCorrect;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: _hasAnswered ? null : () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCorrect
                            ? Colors.green.withOpacity(0.2)
                            : isWrong
                                ? Colors.red.withOpacity(0.2)
                                : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          question.options[index],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_hasAnswered) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestionIndex < widget.quiz.questions.length - 1
                      ? Translations.get('nextQuestion', language)
                      : Translations.get('showResults', language),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}