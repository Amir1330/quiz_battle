import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/translations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<SettingsProvider>().language;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('settings', language)),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              ListTile(
                title: Text(Translations.get('theme', language)),
                subtitle: Text(
                  settings.themeMode == ThemeMode.system
                      ? Translations.get('system', language)
                      : settings.themeMode == ThemeMode.light
                          ? Translations.get('light', language)
                          : Translations.get('dark', language),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(Translations.get('selectTheme', language)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(Translations.get('system', language)),
                            onTap: () {
                              settings.setThemeMode(ThemeMode.system);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(Translations.get('light', language)),
                            onTap: () {
                              settings.setThemeMode(ThemeMode.light);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(Translations.get('dark', language)),
                            onTap: () {
                              settings.setThemeMode(ThemeMode.dark);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(Translations.get('language', language)),
                subtitle: Text(
                  language == 'en'
                      ? Translations.get('english', language)
                      : language == 'ru'
                          ? Translations.get('russian', language)
                          : Translations.get('kazakh', language),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(Translations.get('selectLanguage', language)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(Translations.get('english', language)),
                            onTap: () {
                              settings.setLanguage('en');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(Translations.get('russian', language)),
                            onTap: () {
                              settings.setLanguage('ru');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(Translations.get('kazakh', language)),
                            onTap: () {
                              settings.setLanguage('kk');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
} 