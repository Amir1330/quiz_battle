import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  // Default language
  Locale _locale = const Locale('en');

  // Key for shared preferences
  static const String _localeKey = 'locale';

  LanguageProvider() {
    // Load saved locale on initialization
    _loadSavedLocale();
  }

  Locale get locale => _locale;

  // Load previously saved locale
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      
      if (savedLocale != null) {
        _locale = Locale(savedLocale);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
  }

  // Set and save the new locale
  Future<void> setLocale(String languageCode) async {
    if (languageCode == _locale.languageCode) return;
    
    // Set the new locale
    _locale = Locale(languageCode);
    notifyListeners();
    
    // Save the new locale to shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  // Method to get the current language name
  String get currentLanguageName {
    switch (_locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'kk':
        return 'Қазақша';
      case 'en':
      default:
        return 'English';
    }
  }
} 