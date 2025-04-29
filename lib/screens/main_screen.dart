import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/translations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('appTitle', language)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to Quiz Battle!'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: Text(Translations.get('play', language)),
              onTap: () => Navigator.pushNamed(context, '/play'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(Translations.get('settings', language)),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(Translations.get('about', language)),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }
}