import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzz/providers/theme_provider.dart';
import 'package:quizzz/providers/language_provider.dart';
import 'package:quizzz/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.theme,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      icon: const Icon(Icons.brightness_auto),
                      label: Text(localizations.systemTheme),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      icon: const Icon(Icons.light_mode),
                      label: Text(localizations.lightTheme),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      icon: const Icon(Icons.dark_mode),
                      label: Text(localizations.darkTheme),
                    ),
                  ],
                  selected: {themeProvider.themeMode},
                  onSelectionChanged: (Set<ThemeMode> selected) {
                    themeProvider.setThemeMode(selected.first);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.language,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'en',
                      label: Text('English'),
                    ),
                    ButtonSegment<String>(
                      value: 'ru',
                      label: Text('Русский'),
                    ),
                    ButtonSegment<String>(
                      value: 'kk',
                      label: Text('Қазақша'),
                    ),
                  ],
                  selected: {languageProvider.locale.languageCode},
                  onSelectionChanged: (Set<String> selected) {
                    languageProvider.setLocale(selected.first);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 