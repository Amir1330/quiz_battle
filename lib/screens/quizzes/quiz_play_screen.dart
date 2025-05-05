import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:quizzz/l10n/app_localizations.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedOptionIndex;
  Timer? _timer;
  int _timeLeft = 0;

  @override
  void initState() {
    super.initState();
    if (widget.quiz.timeLimit > 0) {
      _timeLeft = widget.quiz.timeLimit;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _nextQuestion();
        }
      });
    });
  }

  void _checkAnswer(int selectedIndex) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = selectedIndex;
      if (selectedIndex == widget.quiz.questions[_currentQuestionIndex].correctOptionIndex) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOptionIndex = null;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(localizations.quizResults),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${localizations.correctAnswers}: $_score/${widget.quiz.questions.length}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              '${(_score / widget.quiz.questions.length * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to quiz details
            },
            child: Text(localizations.done),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${localizations.question} ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}'),
        actions: [
          if (widget.quiz.timeLimit > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '$_timeLeft s',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...List.generate(
              question.options.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: _isAnswered ? null : () => _checkAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getOptionColor(index),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: Text(
                    question.options[index],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _isAnswered ? Colors.white : null,
                        ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
            ),
          ],
        ),
      ),
    );
  }

  Color? _getOptionColor(int index) {
    if (!_isAnswered) return null;

    if (index == widget.quiz.questions[_currentQuestionIndex].correctOptionIndex) {
      return Colors.green;
    }
    if (index == _selectedOptionIndex) {
      return Colors.red;
    }
    return null;
  }
} 