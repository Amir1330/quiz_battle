import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:quizzz/providers/quiz_provider.dart';
import 'package:quizzz/screens/quizzes/quiz_details_screen.dart';

class PlayQuizScreen extends StatefulWidget {
  const PlayQuizScreen({super.key});

  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // Don't keep state alive between tab switches

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the build is complete before calling the async method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuizzes();
    });
  }
  
  Future<void> _loadQuizzes() async {
    debugPrint('Loading all quizzes in PlayQuizScreen');
    try {
      await Provider.of<QuizProvider>(context, listen: false).loadQuizzes();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading quizzes: $e')),
        );
      }
    }
  }

  Future<void> _refreshQuizzes() async {
    await Provider.of<QuizProvider>(context, listen: false).loadQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final quizProvider = Provider.of<QuizProvider>(context);

    return RefreshIndicator(
      onRefresh: _refreshQuizzes,
      child: Stack(
        children: [
          if (quizProvider.quizzes.isEmpty && !quizProvider.isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No quizzes available yet. Be the first to create one!',
                      textAlign: TextAlign.center,
                    ),
                    if (quizProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Error: ${quizProvider.error}',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _refreshQuizzes,
                        child: const Text('Retry'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (quizProvider.quizzes.isNotEmpty)
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: quizProvider.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizProvider.quizzes[index];
                return QuizCard(quiz: quiz);
              },
            ),
          if (quizProvider.isLoading && quizProvider.quizzes.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final Quiz quiz;

  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QuizDetailsScreen(quiz: quiz),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                quiz.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${quiz.questions.length} questions',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'By ${quiz.creatorEmail}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 