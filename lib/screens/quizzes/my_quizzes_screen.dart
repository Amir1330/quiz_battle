import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:quizzz/providers/auth_provider.dart';
import 'package:quizzz/providers/quiz_provider.dart';
import 'package:quizzz/screens/quizzes/quiz_details_screen.dart';
import 'package:quizzz/l10n/app_localizations.dart';
import 'package:quizzz/screens/auth/login_screen.dart';

class MyQuizzesScreen extends StatefulWidget {
  const MyQuizzesScreen({super.key});

  @override
  State<MyQuizzesScreen> createState() => _MyQuizzesScreenState();
}

class _MyQuizzesScreenState extends State<MyQuizzesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // Don't keep state alive between tab switches

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the build is complete before calling the async method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMyQuizzes();
    });
  }

  Future<void> _loadMyQuizzes() async {
    debugPrint('Loading my quizzes in MyQuizzesScreen');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user; // Use the corrected user getter

    if (currentUser != null) {
      debugPrint(
        'Authenticated user found: ${currentUser.email}, loading quizzes for ${currentUser.uid}',
      );
      try {
        await Provider.of<QuizProvider>(
          context,
          listen: false,
        ).loadMyQuizzes(currentUser.uid);
      } catch (e) {
        debugPrint('Error loading quizzes: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error loading quizzes: $e')));
        }
      }
    } else {
      debugPrint('User is not authenticated, cannot load quizzes');
    }
  }

  Future<void> _refreshMyQuizzes() async {
    debugPrint('Refreshing my quizzes');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user; // Use the corrected user getter

    if (currentUser != null) {
      debugPrint('Refreshing quizzes for user ${currentUser.uid}');
      try {
        await Provider.of<QuizProvider>(
          context,
          listen: false,
        ).loadMyQuizzes(currentUser.uid);
      } catch (e) {
        debugPrint('Error refreshing quizzes: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to refresh quizzes: $e')),
          );
        }
      }
    } else {
      debugPrint('Cannot refresh quizzes - user not authenticated');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to view your quizzes')),
        );
      }
    }

    return Future.value();
  }

  Future<void> _deleteQuiz(Quiz quiz) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Quiz'),
            content: const Text('Are you sure you want to delete this quiz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<QuizProvider>(
          context,
          listen: false,
        ).deleteQuiz(context, quiz.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz deleted successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final quizProvider = Provider.of<QuizProvider>(context);
    final localizations = AppLocalizations.of(context);

    if (Provider.of<AuthProvider>(context).isGuest) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.myQuizzes)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.registrationRequired,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(localizations.signup),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.myQuizzes)),
      body: Stack(
        children: [
          if (quizProvider.quizzes.isEmpty && !quizProvider.isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'You haven\'t created any quizzes yet.',
                      textAlign: TextAlign.center,
                    ),
                    if (quizProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Error: ${quizProvider.error}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _refreshMyQuizzes,
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(quiz.title),
                    subtitle: Text(
                      '${quiz.questions.length} questions • Created ${_formatDate(quiz.createdAt)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => QuizDetailsScreen(quiz: quiz),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteQuiz(quiz),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          if (quizProvider.isLoading && quizProvider.quizzes.isEmpty)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
