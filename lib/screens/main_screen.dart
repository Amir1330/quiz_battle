import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/translations.dart';
import 'play_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load quizzes when the main screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).loadQuizzes();
    });
  }

  void _onNavigationItemTapped(int index) {
    if (index == 0) {
      // Settings
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    } else if (index == 1) {
      // About
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final language = context.watch<SettingsProvider>().language;
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      
      // Define specific colors for dark and light themes
      final Color gradientStart = isDarkMode ? const Color(0xFF1A237E) : const Color(0xFF673AB7);
      final Color gradientEnd = isDarkMode ? const Color(0xFF303F9F) : const Color(0xFF9575CD);
      final Color iconColor = isDarkMode ? Colors.white : Colors.white;
      final Color textColor = isDarkMode ? Colors.white : Colors.white;
      
      final Color mainButtonBg = isDarkMode ? const Color(0xFF212121) : Colors.white;
      final Color mainButtonText = isDarkMode ? Colors.white : const Color(0xFF673AB7);
      
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradientStart,
                gradientEnd,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and app title
                  const Spacer(flex: 2),
                  Icon(
                    Icons.quiz,
                    size: 90,
                    color: iconColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'QUIZ BATTLE',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const Spacer(flex: 1),
                  
                  // Play button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlayScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainButtonBg,
                        foregroundColor: mainButtonText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        Translations.get('play', language),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainButtonText,
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDarkMode ? const Color(0xFF1A237E) : const Color(0xFF673AB7),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: Translations.get('settings', language),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.info),
              label: Translations.get('about', language),
            ),
          ],
          onTap: _onNavigationItemTapped,
        ),
      );
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Text('Error loading main screen: $e'),
        ),
      );
    }
  }
}