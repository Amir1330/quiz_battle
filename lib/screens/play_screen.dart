import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/settings_provider.dart';
import '../models/quiz.dart';
import '../utils/translations.dart';
import 'create_quiz_screen.dart';
import 'quiz_game_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    await context.read<QuizProvider>().loadQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('availableQuizzes', language)),
        centerTitle: true,
      ),
      body: Consumer2<QuizProvider, SettingsProvider>(
        builder: (context, quizProvider, settingsProvider, child) {
          final quizzes = [
            ...quizProvider.defaultQuizzes,
            ...quizProvider.getQuizzesByLanguage(language),
          ];

          if (quizzes.isEmpty) {
            return Center(
              child: Text(Translations.get('noQuizzes', language)),
            );
          }

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(quiz.title),
                  subtitle: Text(quiz.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!quiz.isDefault) ...[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateQuizScreen(
                                  quiz: quiz,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(Translations.get('deleteQuiz', language)),
                                content: Text(
                                  Translations.get('deleteQuizConfirm', language),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(Translations.get('cancel', language)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      quizProvider.deleteQuiz(quiz.id);
                                      Navigator.pop(context);
                                    },
                                    child: Text(Translations.get('delete', language)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizGameScreen(quiz: quiz),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuizScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
