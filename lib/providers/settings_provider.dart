import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  
  late SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'en';

  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[_prefs.getInt(_themeKey) ?? ThemeMode.system.index];
    _language = _prefs.getString(_languageKey) ?? 'en';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _language = languageCode;
    await _prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }
} 