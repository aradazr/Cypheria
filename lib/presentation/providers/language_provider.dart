import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('fa', 'IR');

  Locale get locale => _locale;

  bool get isPersian => _locale.languageCode == 'fa';

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'fa'
        ? const Locale('en', 'US')
        : const Locale('fa', 'IR');
    notifyListeners();
  }
}

