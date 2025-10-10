import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  // Supported languages for SickBall
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('zh', 'TW'), // Traditional Chinese
  ];

  // Language display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'zh_TW': '繁體中文',
  };

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);

      if (savedLanguage != null) {
        _currentLocale = Locale(savedLanguage);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    try {
      _currentLocale = locale;
      notifyListeners();

      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);

      print('✅ Language changed to: ${locale.languageCode}');
    } catch (e) {
      print('❌ Error saving language: $e');
    }
  }

  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode.toUpperCase();
  }

  bool isCurrentLanguage(Locale locale) {
    return _currentLocale.languageCode == locale.languageCode;
  }
}
