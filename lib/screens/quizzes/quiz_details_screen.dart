import 'package:flutter/material.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:quizzz/screens/quizzes/quiz_play_screen.dart';
import 'package:quizzz/l10n/app_localizations.dart';

class QuizDetailsScreen extends StatelessWidget {
  final Quiz quiz;

  const QuizDetailsScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.description,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quiz.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    localizations.questions,
                    '${quiz.questions.length}',
                  ),
                  const Divider(),
                  _buildDetailRow(
                    context,
                    'Created by',
                    quiz.creatorEmail,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    context,
                    localizations.timeLimit,
                    quiz.timeLimit > 0
                        ? '${quiz.timeLimit} seconds'
                        : 'No time limit',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuizPlayScreen(quiz: quiz),
                ),
              );
            },
            child: Text(localizations.startQuiz),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
} 