import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/settings_provider.dart';
import 'providers/quiz_provider.dart';
import 'services/firebase_service.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/play_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize services
  final firebaseService = FirebaseService();
  await firebaseService.initialize();
  
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(MyApp(settingsProvider: settingsProvider));
}

class MyApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  
  const MyApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Quiz Battle',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: settings.themeMode,
            locale: Locale(settings.language),
            initialRoute: '/',
            routes: {
              '/': (context) => const MainScreen(),
              '/play': (context) => const PlayScreen(),
              '/about': (context) => const AboutScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}

// В методе _saveQuiz класса _CreateQuizScreenState:
void _saveQuiz() async {
  if (_formKey.currentState!.validate() && _questions.isNotEmpty) {
    final quiz = Quiz(
      id: widget.quiz?.id,
      title: _titleController.text,
      description: _descriptionController.text,
      questions: _questions,
      language: _selectedLanguage,
    );

    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    try {
      if (widget.quiz == null) {
        await quizProvider.addQuiz(quiz);
      } else {
        await quizProvider.updateQuiz(quiz);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving quiz: $e')),
      );
    }
  }
}
