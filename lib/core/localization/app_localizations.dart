import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'fa': {
      'appTitle': 'رمزگذار متن',
      'encoding': 'رمزگذاری',
      'decoding': 'رمزگشایی',
      'encryptionKey': 'کلید رمزگذاری',
      'enterKey': 'کلید خود را وارد کنید',
      'originalText': 'متن اصلی',
      'encryptedText': 'متن رمزگذاری شده',
      'decryptedText': 'متن رمزگشایی شده',
      'enterText': 'متن خود را وارد کنید...',
      'enterEncryptedText': 'متن رمزگذاری شده را وارد کنید...',
      'resultHere': 'نتیجه اینجا نمایش داده می‌شود',
      'copyToInput': 'کپی به ورودی',
      'clearAll': 'پاک کردن همه',
      'textCopied': 'متن به ورودی کپی شد',
      'copied': 'کپی شد',
      'pleaseEnterText': 'لطفاً متن را وارد کنید',
      'pleaseEnterKey': 'لطفاً کلید را وارد کنید',
    },
    'en': {
      'appTitle': 'Text Encoder',
      'encoding': 'Encode',
      'decoding': 'Decode',
      'encryptionKey': 'Encryption Key',
      'enterKey': 'Enter your key',
      'originalText': 'Original Text',
      'encryptedText': 'Encrypted Text',
      'decryptedText': 'Decrypted Text',
      'enterText': 'Enter your text...',
      'enterEncryptedText': 'Enter encrypted text...',
      'resultHere': 'Result will be shown here',
      'copyToInput': 'Copy to Input',
      'clearAll': 'Clear All',
      'textCopied': 'Text copied to input',
      'copied': 'Copied',
      'pleaseEnterText': 'Please enter text',
      'pleaseEnterKey': 'Please enter key',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get encoding => _localizedValues[locale.languageCode]!['encoding']!;
  String get decoding => _localizedValues[locale.languageCode]!['decoding']!;
  String get encryptionKey =>
      _localizedValues[locale.languageCode]!['encryptionKey']!;
  String get enterKey => _localizedValues[locale.languageCode]!['enterKey']!;
  String get originalText =>
      _localizedValues[locale.languageCode]!['originalText']!;
  String get encryptedText =>
      _localizedValues[locale.languageCode]!['encryptedText']!;
  String get decryptedText =>
      _localizedValues[locale.languageCode]!['decryptedText']!;
  String get enterText =>
      _localizedValues[locale.languageCode]!['enterText']!;
  String get enterEncryptedText =>
      _localizedValues[locale.languageCode]!['enterEncryptedText']!;
  String get resultHere =>
      _localizedValues[locale.languageCode]!['resultHere']!;
  String get copyToInput =>
      _localizedValues[locale.languageCode]!['copyToInput']!;
  String get clearAll => _localizedValues[locale.languageCode]!['clearAll']!;
  String get textCopied =>
      _localizedValues[locale.languageCode]!['textCopied']!;
  String get copied => _localizedValues[locale.languageCode]!['copied']!;
  String get pleaseEnterText =>
      _localizedValues[locale.languageCode]!['pleaseEnterText']!;
  String get pleaseEnterKey =>
      _localizedValues[locale.languageCode]!['pleaseEnterKey']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fa', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

