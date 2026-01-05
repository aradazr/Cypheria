import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// Helper class to get localized strings without BuildContext
class LocalizationHelper {
  static String getString(Locale locale, String key) {
    return AppLocalizations.getString(locale, key);
  }
}

