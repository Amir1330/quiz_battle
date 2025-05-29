import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/connection_status.dart';
import '../models/quiz_data.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({Key? key}) : super(key: key);

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<QuizProvider>().loadQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Викторины'),
        actions: const [
          ConnectionStatus(),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (quizProvider.quizzes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Нет доступных викторин',
                    style: TextStyle(fontSize: 18),
                  ),
                  if (quizProvider.isOffline) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => quizProvider.syncWithServer(),
                      child: const Text('Синхронизировать'),
                    ),
                  ],
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => quizProvider.loadQuizzes(),
            child: ListView.builder(
              itemCount: quizProvider.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizProvider.quizzes[index];
                return QuizCard(quiz: quiz);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Навигация к экрану создания викторины
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final QuizData quiz;

  const QuizCard({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(quiz.question),
        subtitle: Text('Категория: ${quiz.category}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Навигация к экрану редактирования
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Удаление викторины'),
                    content: const Text(
                        'Вы уверены, что хотите удалить эту викторину?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Удалить'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  final quizProvider = context.read<QuizProvider>();
                  await quizProvider.deleteQuiz(quiz.id);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Викторина удалена'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        onTap: () {
          // Навигация к экрану прохождения викторины
        },
      ),
    );
  }
}
