import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/main_screen.dart';
import 'screens/about_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/play_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
    
    final settingsProvider = SettingsProvider();
    await settingsProvider.loadSettings();
    
    final quizProvider = QuizProvider();
    await quizProvider.loadQuizzes();
    
    runApp(MyApp(
      settingsProvider: settingsProvider,
      quizProvider: quizProvider,
    ));
  } catch (e) {
    debugPrint('Error during initialization: $e');
    // Показать сообщение об ошибке пользователю
  }
}

class MyApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final QuizProvider quizProvider;
  
  const MyApp({
    super.key, 
    required this.settingsProvider,
    required this.quizProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: quizProvider),
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
