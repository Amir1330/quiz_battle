import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

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
    try {
      final prefs = await SharedPreferences.getInstance();

      // Определяем язык системы
      String defaultLanguage = 'en';
      if (Platform.localeName.startsWith('ru')) {
        defaultLanguage = 'ru';
      } else if (Platform.localeName.startsWith('kk')) {
        defaultLanguage = 'kk';
      }

      _language = prefs.getString(_languageKey) ?? defaultLanguage;
      _themeMode =
          ThemeMode.values[prefs.getInt(_themeModeKey) ??
              ThemeMode.system.index];

      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка загрузки настроек: $e');
      // Используем значения по умолчанию в случае ошибки
      _language = 'en';
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setLanguage(String lang) async {
    if (_language != lang) {
      try {
        _language = lang;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, lang);
        notifyListeners();
      } catch (e) {
        debugPrint('Ошибка сохранения языка: $e');
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      try {
        _themeMode = mode;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_themeModeKey, mode.index);
        notifyListeners();
      } catch (e) {
        debugPrint('Ошибка сохранения темы: $e');
      }
    }
  }
}
