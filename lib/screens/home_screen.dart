import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz.dart';
import '../utils/translations.dart';
import 'play_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('appTitle', language)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final quizProvider = context.read<QuizProvider>();
                quizProvider.loadQuestions([
                  Question(
                    question: 'What is Flutter?',
                    options: [
                      'A mobile development framework',
                      'A programming language',
                      'A database',
                      'A design tool',
                    ],
                    correctOptionIndex: 0,
                  ),
                  // Add more questions here
                ]);
                // TODO: Navigate to quiz screen
              },
              child: Text(Translations.get('play', language)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
