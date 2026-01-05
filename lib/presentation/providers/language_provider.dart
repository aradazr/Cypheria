import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('fa', 'IR');
  bool _isLoading = true;

  Locale get locale => _locale;
  bool get isPersian => _locale.languageCode == 'fa';
  bool get isLoading => _isLoading;

  LanguageProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      
      if (languageCode != null) {
        if (languageCode == 'fa') {
          _locale = const Locale('fa', 'IR');
        } else if (languageCode == 'en') {
          _locale = const Locale('en', 'US');
        }
      }
    } catch (e) {
      _locale = const Locale('fa', 'IR');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, locale.languageCode);
      } catch (e) {
        // Handle error silently
      }
    }
  }

  Future<void> toggleLanguage() async {
    _locale = _locale.languageCode == 'fa'
        ? const Locale('en', 'US')
        : const Locale('fa', 'IR');
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, _locale.languageCode);
    } catch (e) {
      // Handle error silently
    }
  }
}

