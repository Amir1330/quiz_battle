import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzz/providers/auth_provider.dart';
import 'package:quizzz/providers/quiz_provider.dart';
import 'package:quizzz/models/quiz_history.dart';

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final quizProvider = Provider.of<QuizProvider>(context);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz History')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Please sign in to view your quiz history',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz History')),
      body: FutureBuilder<List<QuizHistory>>(
        future: quizProvider.getUserQuizHistory(authProvider.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry loading history
                      quizProvider.getUserQuizHistory(authProvider.user!.uid);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No quiz history yet', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final percentage = (item.score / item.totalQuestions) * 100;
              Color scoreColor;

              if (percentage >= 80) {
                scoreColor = Colors.green;
              } else if (percentage >= 60) {
                scoreColor = Colors.orange;
              } else {
                scoreColor = Colors.red;
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    'Score: ${item.score}/${item.totalQuestions}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Completed: ${item.completedAt.toString().split('.')[0]}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: item.score / item.totalQuestions,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
