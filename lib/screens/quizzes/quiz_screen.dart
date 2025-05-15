import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:quizzz/models/quiz_history.dart';
import 'package:quizzz/providers/auth_provider.dart';
import 'package:quizzz/providers/quiz_provider.dart';
import 'package:quizzz/l10n/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Quiz quiz;
  late DateTime _startTime;
  bool _isSubmitting = false;
  List<int> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    quiz = widget.quiz;
    _startTime = DateTime.now();
    _selectedAnswers = List.filled(quiz.questions.length, -1);
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      if (_selectedAnswers[i] == quiz.questions[i].correctOptionIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quiz.title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quiz.questions.length,
        itemBuilder: (context, index) {
          final question = quiz.questions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${question.question}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    question.options.length,
                    (optionIndex) => RadioListTile<int>(
                      title: Text(question.options[optionIndex]),
                      value: optionIndex,
                      groupValue: _selectedAnswers[index],
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswers[index] = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitQuiz,
          child:
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : Text(AppLocalizations.of(context).submit),
        ),
      ),
    );
  }

  Future<void> _submitQuiz() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final score = _calculateScore();
      final totalQuestions = quiz.questions.length;
      final timeSpent = DateTime.now().difference(_startTime).inSeconds;

      final history = QuizHistory(
        id: const Uuid().v4(),
        userId: Provider.of<AuthProvider>(context, listen: false).user!.uid,
        quizId: quiz.id,
        quizTitle: quiz.title,
        score: score,
        totalQuestions: totalQuestions,
        completedAt: DateTime.now(),
        timeSpent: timeSpent,
      );

      await Provider.of<QuizProvider>(
        context,
        listen: false,
      ).addQuizHistory(context, history);

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text(AppLocalizations.of(context).quizCompleted),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context).score}: $score/$totalQuestions',
                  ),
                  Text(
                    '${AppLocalizations.of(context).timeSpent}: $timeSpent ${AppLocalizations.of(context).seconds}',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).ok),
                ),
              ],
            ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context).errorSavingResults}: ${e.toString()}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
