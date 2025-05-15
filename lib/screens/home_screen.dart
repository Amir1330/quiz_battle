import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzz/providers/auth_provider.dart';
import 'package:quizzz/providers/quiz_provider.dart';
import 'package:quizzz/screens/auth/login_screen.dart';
import 'package:quizzz/screens/quizzes/create_quiz_screen.dart';
import 'package:quizzz/screens/quizzes/my_quizzes_screen.dart';
import 'package:quizzz/screens/quizzes/play_quiz_screen.dart';
import 'package:quizzz/screens/settings_screen.dart';
import 'package:quizzz/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // We'll rebuild these each time to ensure they're fresh
  List<Widget> _getScreens() {
    return [
      const PlayQuizScreen(),
      const MyQuizzesScreen(),
      const CreateQuizScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
    // Initial loading of relevant data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCurrentTab();
    });
  }

  // Helper method to refresh data for the current tab
  void _refreshCurrentTab() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_selectedIndex == 0) {
      // Play tab
      debugPrint('Refreshing Play tab data');
      quizProvider.loadQuizzes();
    } else if (_selectedIndex == 1 && authProvider.user != null) {
      // My Quizzes tab
      debugPrint('Refreshing My Quizzes tab data');
      quizProvider.loadMyQuizzes(authProvider.user!.uid);
    }
  }

  void _onItemTapped(int index) {
    // Only do something if we're actually changing tabs
    if (_selectedIndex != index) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Always refresh when navigating to tabs with quizzes
      if (index == 0) {
        // Play tab - refresh all quizzes
        debugPrint('Navigating to Play tab, refreshing quizzes');
        quizProvider.loadQuizzes();
      } else if (index == 1 && authProvider.user != null) {
        // My Quizzes tab - refresh my quizzes
        debugPrint('Navigating to My Quizzes tab, refreshing my quizzes');
        quizProvider.loadMyQuizzes(authProvider.user!.uid);
      }

      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final localizations = AppLocalizations.of(context);

    // Get fresh screens to avoid stale data
    final screens = _getScreens();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          if (authProvider.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authProvider.signOut();
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              tooltip: localizations.logout,
            )
          else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => Navigator.of(context).pushNamed('/login'),
            ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.play_circle_outline),
            label: localizations.play,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list),
            label: localizations.myQuizzes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            label: localizations.create,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: localizations.settings,
          ),
        ],
      ),
    );
  }
}
