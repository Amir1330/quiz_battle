import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzz/providers/auth_provider.dart';
import 'package:quizzz/providers/quiz_provider.dart';
import 'package:quizzz/l10n/app_localizations.dart';
import 'package:quizzz/screens/auth/login_screen.dart';
import 'package:intl/intl.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(
        context,
        listen: false,
      ).loadQuizHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final localizations = AppLocalizations.of(context);

    if (authProvider.isGuest) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.quizHistory)),
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
      appBar: AppBar(title: Text(localizations.quizHistory)),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quizProvider.error != null) {
            return Center(
              child: Text(
                quizProvider.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final history = quizProvider.quizHistory;
          if (history.isEmpty) {
            return Center(child: Text(localizations.noHistoryFound));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(item.quizTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${localizations.score}: ${item.score}/${item.totalQuestions}',
                      ),
                      Text(
                        '${localizations.timeSpent}: ${item.timeSpent} ${localizations.seconds}',
                      ),
                      Text(
                        DateFormat.yMMMd().add_jm().format(item.completedAt),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed:
                        () => quizProvider.deleteQuizHistory(context, item.id),
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
