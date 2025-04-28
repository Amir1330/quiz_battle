import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final String _languageKey = 'language';
  final String _themeModeKey = 'themeMode';

  String _language = 'en';
  ThemeMode _themeMode = ThemeMode.system;

  String get language => _language;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString(_languageKey) ?? 'en';
    _themeMode = ThemeMode.values[prefs.getInt(_themeModeKey) ?? 0];
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    if (_language != lang) {
      _language = lang;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, lang);
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
      notifyListeners();
    }
  }
}
