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
import 'package:firebase_database/firebase_database.dart';
import 'dart:io' show Platform;
import 'services/firebase_service.dart';

Future<void> runQuizBattleApp() async {
  try {
    debugPrint('Starting app initialization...');
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('Flutter binding initialized');

    // Initialize Firebase with the new project configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    debugPrint('Firebase initialized with project: ${DefaultFirebaseOptions.currentPlatform.projectId}');
    
    if (!Platform.isLinux) {
      // Enable persistence for Realtime Database
      try {
        FirebaseDatabase.instance.setPersistenceEnabled(true);
        debugPrint('Firebase Realtime Database persistence enabled');
      } catch (e) {
        debugPrint('Could not enable Firebase persistence: $e');
      }
    }

    // Initialize providers
    final settingsProvider = SettingsProvider();
    await settingsProvider.loadSettings();
    debugPrint('Settings loaded successfully');

    final quizProvider = QuizProvider();
    debugPrint('QuizProvider created');
    
    // Run the app
    runApp(
      MyApp(settingsProvider: settingsProvider, quizProvider: quizProvider),
    );
    
    // Load quizzes after UI is shown for better UX
    await quizProvider.loadQuizzes();
    debugPrint('Quizzes loaded: ${quizProvider.quizzes.length}');
    
    debugPrint('App started successfully');
  } catch (e, stackTrace) {
    debugPrint('Critical error during initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Произошла ошибка при запуске приложения',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    runQuizBattleApp();
                  },
                  child: const Text('Попробовать снова'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() async {
  runQuizBattleApp();
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
