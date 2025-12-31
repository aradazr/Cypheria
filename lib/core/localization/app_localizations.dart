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
      'skip': 'رد کردن',
      'next': 'بعدی',
      'getStarted': 'شروع کنید',
      'onboardingTitle1': 'به Cypheria خوش آمدید',
      'onboardingDescription1': 'یک اپلیکیشن امن و مدرن برای رمزگذاری و رمزگشایی متن‌های شما',
      'onboardingTitle2': 'رمزگذاری با کلید اختصاصی',
      'onboardingDescription2': 'کلید خود را انتخاب کنید و متن‌هایتان را با امنیت بالا رمزگذاری کنید',
      'onboardingTitle3': 'تبدیل آسان',
      'onboardingDescription3': 'به راحتی بین حالت رمزگذاری و رمزگشایی جابجا شوید',
      'onboardingTitle4': 'آماده استفاده',
      'onboardingDescription4': 'حالا می‌توانید از تمام قابلیت‌های Cypheria استفاده کنید',
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
      'skip': 'Skip',
      'next': 'Next',
      'getStarted': 'Get Started',
      'onboardingTitle1': 'Welcome to Cypheria',
      'onboardingDescription1': 'A secure and modern app for encrypting and decrypting your texts',
      'onboardingTitle2': 'Encryption with Custom Key',
      'onboardingDescription2': 'Choose your key and encrypt your texts with high security',
      'onboardingTitle3': 'Easy Switching',
      'onboardingDescription3': 'Easily switch between encoding and decoding modes',
      'onboardingTitle4': 'Ready to Use',
      'onboardingDescription4': 'Now you can use all Cypheria features',
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
  String get skip => _localizedValues[locale.languageCode]!['skip']!;
  String get next => _localizedValues[locale.languageCode]!['next']!;
  String get getStarted =>
      _localizedValues[locale.languageCode]!['getStarted']!;
  String get onboardingTitle1 =>
      _localizedValues[locale.languageCode]!['onboardingTitle1']!;
  String get onboardingDescription1 =>
      _localizedValues[locale.languageCode]!['onboardingDescription1']!;
  String get onboardingTitle2 =>
      _localizedValues[locale.languageCode]!['onboardingTitle2']!;
  String get onboardingDescription2 =>
      _localizedValues[locale.languageCode]!['onboardingDescription2']!;
  String get onboardingTitle3 =>
      _localizedValues[locale.languageCode]!['onboardingTitle3']!;
  String get onboardingDescription3 =>
      _localizedValues[locale.languageCode]!['onboardingDescription3']!;
  String get onboardingTitle4 =>
      _localizedValues[locale.languageCode]!['onboardingTitle4']!;
  String get onboardingDescription4 =>
      _localizedValues[locale.languageCode]!['onboardingDescription4']!;
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

