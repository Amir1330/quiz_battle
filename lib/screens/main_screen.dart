import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/translations.dart';
import 'home_screen.dart';
import 'about_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  static const List<Widget> _screens = [
    HomeScreen(),
    AboutScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;
    
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return _screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: Translations.get('home', language),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info),
            label: Translations.get('about', language),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: Translations.get('settings', language),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}