import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quizzz/providers/theme_provider.dart';
import 'package:quizzz/providers/auth_provider.dart';
import 'package:quizzz/providers/quiz_provider.dart';
import 'package:quizzz/providers/language_provider.dart';
import 'package:quizzz/providers/connectivity_provider.dart';
import 'package:quizzz/providers/storage_provider.dart';
import 'package:quizzz/providers/sync_provider.dart';
import 'package:quizzz/screens/splash_screen.dart';
import 'package:quizzz/screens/auth/login_screen.dart';
import 'package:quizzz/l10n/app_localizations.dart';
import 'package:quizzz/widgets/offline_banner.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }

  // Initialize Hive and StorageProvider instance
  late StorageProvider storageProvider;
  try {
    await StorageProvider.init();
    storageProvider = StorageProvider(); // Create an instance after init
    debugPrint('Hive and StorageProvider initialized successfully');
  } catch (e) {
    debugPrint('Error initializing Hive and StorageProvider: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageProvider>(create: (_) => storageProvider), // Provide the instance
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(
          create: (context) => QuizProvider(
            Provider.of<StorageProvider>(context, listen: false),
            Provider.of<ConnectivityProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SyncProvider>(
          create: (context) => SyncProvider(
            Provider.of<StorageProvider>(context, listen: false),
            Provider.of<ConnectivityProvider>(context, listen: false),
            Provider.of<QuizProvider>(context, listen: false),
          ),
          update: (context, auth, previous) => SyncProvider(
            Provider.of<StorageProvider>(context, listen: false),
            Provider.of<ConnectivityProvider>(context, listen: false),
            Provider.of<QuizProvider>(context, listen: false),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Quizzz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeProvider.themeMode,
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('kk'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('kk');
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return const Locale('kk');
      },
      home: const Scaffold(
        body: Column(
          children: [
            OfflineBanner(),
            Expanded(
              child: SplashScreen(),
            ),
          ],
        ),
      ),
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
