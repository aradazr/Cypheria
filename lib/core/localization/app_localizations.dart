import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static String getString(Locale locale, String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'fa': {
      'appTitle': 'سایفریا',
      'imageEncodingTab': 'رمزگذاری عکس',
      'textEncodingTab': 'رمزگذاری متن',
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
      'onboardingDescription1':
          'یک اپلیکیشن امن و مدرن برای رمزگذاری و رمزگشایی متن‌های شما',
      'onboardingTitle2': 'رمزگذاری با کلید اختصاصی',
      'onboardingDescription2':
          'کلید خود را انتخاب کنید و متن‌هایتان را با امنیت بالا رمزگذاری کنید',
      'onboardingTitle3': 'تبدیل آسان',
      'onboardingDescription3':
          'به راحتی بین حالت رمزگذاری و رمزگشایی جابجا شوید',
      'onboardingTitle4': 'آماده استفاده',
      'onboardingDescription4':
          'حالا می‌توانید از تمام قابلیت‌های Cypheria استفاده کنید',
      'uploadImageToEncode': 'لطفا عکس مدنظر خود برای رمزنگاری را آپلود کنید',
      'uploadImageToDecode': 'لطفا عکس مدنظر خود برای رمزگشایی را آپلود کنید',
      'saveToGallery': 'ذخیره در گالری',
      'savedToGallery': 'با موفقیت ذخیره شد',
      'share': 'ارسال',
      'encryptedFileSelected': 'فایل رمزگذاری شده انتخاب شده است',
      'decryptToView': 'برای نمایش تصویر، روی دکمه رمزگشایی کلیک کنید',
      'encrypted': 'رمزگذاری شده',
      'pleaseSelectImage': 'لطفاً یک تصویر انتخاب کنید',
      'fileEncodingTab': 'رمزگذاری فایل',
      'uploadFileToEncode': 'لطفا فایل مدنظر خود برای رمزنگاری را انتخاب کنید',
      'uploadFileToDecode': 'لطفا فایل مدنظر خود برای رمزگشایی را انتخاب کنید',
      'audioEncodingTab': 'رمزگذاری صدا',
      'recordAudio': 'ضبط صدا',
      'stopRecording': 'توقف ضبط',
      'playAudio': 'پخش',
      'pauseAudio': 'توقف',
      'recording': 'در حال ضبط...',
      'noAudioRecorded': 'هیچ صدایی ضبط نشده است',
      'audioRecorded': 'صدا با موفقیت ضبط شد',
      'pleaseRecordAudio': 'لطفاً ابتدا صدا را ضبط کنید',
      'audioEncrypted': 'صدا با موفقیت رمزگذاری شد',
      'audioDecrypted': 'صدا با موفقیت رمزگشایی شد',
      'encryptedAudio': 'صدا رمزگذاری شده',
      'decryptedAudio': 'صدا رمزگشایی شده',
      'noEncryptedAudioToSave': 'هیچ صدای رمزگذاری شده‌ای برای ذخیره وجود ندارد',
      'noDecryptedAudioToSave': 'هیچ صدای رمزگشایی شده‌ای برای ذخیره وجود ندارد',
      'noEncryptedAudioToShare': 'هیچ صدای رمزگذاری شده‌ای برای ارسال وجود ندارد',
      'noDecryptedAudioToShare': 'هیچ صدای رمزگشایی شده‌ای برای ارسال وجود ندارد',
      'errorRecordingAudio': 'خطا در ضبط صدا',
      'errorPlayingAudio': 'خطا در پخش صدا',
      'errorEncryptingAudio': 'خطا در رمزگذاری صدا',
      'errorDecryptingAudio': 'خطا در رمزگشایی صدا',
      'recordAgain': 'ضبط مجدد',
      'clearRecording': 'پاک کردن ضبط',
      'privacyPolicy': 'حریم خصوصی',
      'termsOfService': 'قوانین و مقررات',
      'speechToText': 'تبدیل صدا به متن',
      'listening': 'در حال گوش دادن...',
      'speechNotAvailable': 'تبدیل صدا به متن در دسترس نیست',
      'speechPermissionDenied': 'دسترسی به میکروفون رد شد',
      'startListening': 'شروع گوش دادن',
      'stopListening': 'توقف گوش دادن',
      'saveFile': 'ذخیره فایل',
      'savedFile': 'فایل با موفقیت ذخیره شد',
      'fileSelected': 'فایل انتخاب شده است',
      'pleaseSelectFile': 'لطفاً یک فایل انتخاب کنید',
      'saveEncryptedFileDialog': 'ذخیره فایل رمزگذاری شده',
      'saveDecryptedFileDialog': 'ذخیره فایل رمزگشایی شده',
      // Error messages
      'errorSelectingFile': 'خطا در انتخاب فایل',
      'errorSelectingImage': 'خطا در انتخاب تصویر',
      'pleaseEnterEncryptionKey': 'لطفاً کلید رمزگذاری را وارد کنید',
      'encryptionKeyMinLength': 'کلید رمزگذاری باید حداقل ۳ کاراکتر باشد',
      'encryptionKeyCannotBeEmpty': 'کلید رمزگذاری نمی‌تواند خالی باشد',
      'fileNotFound': 'فایل وجود ندارد',
      'fileIsEmpty': 'فایل خالی است',
      'encryptedFileIsEmpty': 'فایل رمزگذاری شده خالی است',
      'errorEncryptingFile': 'خطا در رمزگذاری فایل',
      'errorDecryptingFile': 'خطا در رمزگشایی فایل',
      'wrongKeyOrFile': 'کلید رمزگذاری اشتباه است یا فایل رمزگذاری شده با این کلید رمزگذاری نشده است',
      'noEncryptedFileToSave': 'هیچ فایل رمزگذاری شده‌ای برای ذخیره وجود ندارد',
      'noDecryptedFileToSave': 'هیچ فایل رمزگشایی شده‌ای برای ذخیره وجود ندارد',
      'errorSavingFile': 'خطا در ذخیره فایل',
      'fileNotDecrypted': 'خطا: فایل رمزگشایی نشده است',
      'noEncryptedFileToShare': 'هیچ فایل رمزگذاری شده‌ای برای ارسال وجود ندارد',
      'noDecryptedFileToShare': 'هیچ فایل رمزگشایی شده‌ای برای ارسال وجود ندارد',
      'encryptedFile': 'فایل رمزگذاری شده',
      'decryptedFile': 'فایل رمزگشایی شده',
      'fileNotReadable': 'فایل قابل خواندن نیست',
      'invalidImageFormat': 'فرمت تصویر معتبر نیست. لطفاً یک تصویر معتبر انتخاب کنید',
      'errorReadingImage': 'خطا در خواندن تصویر',
      'errorSavingImage': 'خطا در ذخیره تصویر',
      'errorEncryptingImage': 'خطا در رمزگذاری تصویر',
      'errorDecryptingImage': 'خطا در رمزگشایی تصویر',
      'errorSavingToGallery': 'خطا در ذخیره تصویر در گالری',
      'noEncryptedImageToSave': 'هیچ تصویر رمزگذاری شده‌ای برای ذخیره وجود ندارد',
      'noDecryptedImageToSave': 'هیچ تصویر رمزگشایی شده‌ای برای ذخیره وجود ندارد',
      'noEncryptedImageToShare': 'هیچ تصویر رمزگذاری شده‌ای برای ارسال وجود ندارد',
      'noDecryptedImageToShare': 'هیچ تصویر رمزگشایی شده‌ای برای ارسال وجود ندارد',
      'encryptedImage': 'تصویر رمزگذاری شده',
      'decryptedImage': 'تصویر رمزگشایی شده',
      'encryptedTextIsEmpty': 'متن رمزگذاری شده خالی است',
      'invalidEncryptedTextFormat': 'فرمت متن رمزگذاری شده معتبر نیست. لطفاً متن رمزگذاری شده صحیح را وارد کنید',
      'errorDecrypting': 'خطا در رمزگشایی',
      'switchToPersian': 'تغییر به فارسی',
      'switchToEnglish': 'تغییر به انگلیسی',
      'switchToDark': 'تغییر به تم دارک',
      'switchToLight': 'تغییر به تم روشن',
      'errorDecryptingText': 'خطا در رمزگشایی متن',
      'speechRecognitionFailed': 'تشخیص گفتار با خطا مواجه شد. لطفاً دسترسی میکروفون را بررسی کنید و دوباره تلاش کنید',
      'speechRecognitionFailedIOS': 'تشخیص گفتار فارسی در iOS پشتیبانی نمی‌شود. لطفاً از انگلیسی استفاده کنید یا متن را تایپ کنید',
      'goToSettingsEnableMicrophone': 'لطفاً به تنظیمات بروید و دسترسی میکروفون را فعال کنید',
      'error': 'خطا',
    },
    'en': {
      'appTitle': 'Cypheria',
      'imageEncodingTab': 'Image Encoder',
      'textEncodingTab': 'Text Encoder',
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
      'onboardingDescription1':
          'A secure and modern app for encrypting and decrypting your texts',
      'onboardingTitle2': 'Encryption with Custom Key',
      'onboardingDescription2':
          'Choose your key and encrypt your texts with high security',
      'onboardingTitle3': 'Easy Switching',
      'onboardingDescription3':
          'Easily switch between encoding and decoding modes',
      'onboardingTitle4': 'Ready to Use',
      'onboardingDescription4': 'Now you can use all Cypheria features',
      'uploadImageToEncode': 'Upload Your image to Encode',
      'uploadImageToDecode': 'Upload Your image to Decode',
      'saveToGallery': 'Save To Gallery',
      'savedToGallery': 'Successfully Saved',
      'share': 'Share',
      'encryptedFileSelected': 'Encrypted file selected',
      'decryptToView': 'Click the decode button to view the image',
      'encrypted': 'Encrypted',
      'pleaseSelectImage': 'Please select an image',
      'fileEncodingTab': 'File Encoder',
      'uploadFileToEncode': 'Select your file to encrypt',
      'uploadFileToDecode': 'Select your file to decrypt',
      'audioEncodingTab': 'Audio Encoder',
      'recordAudio': 'Record Audio',
      'stopRecording': 'Stop Recording',
      'playAudio': 'Play',
      'pauseAudio': 'Pause',
      'recording': 'Recording...',
      'noAudioRecorded': 'No audio recorded',
      'audioRecorded': 'Audio recorded successfully',
      'pleaseRecordAudio': 'Please record audio first',
      'audioEncrypted': 'Audio encrypted successfully',
      'audioDecrypted': 'Audio decrypted successfully',
      'encryptedAudio': 'Encrypted Audio',
      'decryptedAudio': 'Decrypted Audio',
      'noEncryptedAudioToSave': 'No encrypted audio to save',
      'noDecryptedAudioToSave': 'No decrypted audio to save',
      'noEncryptedAudioToShare': 'No encrypted audio to share',
      'noDecryptedAudioToShare': 'No decrypted audio to share',
      'errorRecordingAudio': 'Error recording audio',
      'errorPlayingAudio': 'Error playing audio',
      'errorEncryptingAudio': 'Error encrypting audio',
      'errorDecryptingAudio': 'Error decrypting audio',
      'recordAgain': 'Record Again',
      'clearRecording': 'Clear Recording',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'speechToText': 'Speech to Text',
      'listening': 'Listening...',
      'speechNotAvailable': 'Speech recognition not available',
      'speechPermissionDenied': 'Microphone permission denied',
      'startListening': 'Start Listening',
      'stopListening': 'Stop Listening',
      'saveFile': 'Save File',
      'savedFile': 'File saved successfully',
      'fileSelected': 'File selected',
      'pleaseSelectFile': 'Please select a file',
      'saveEncryptedFileDialog': 'Save Encrypted File',
      'saveDecryptedFileDialog': 'Save Decrypted File',
      // Error messages
      'errorSelectingFile': 'Error selecting file',
      'errorSelectingImage': 'Error selecting image',
      'pleaseEnterEncryptionKey': 'Please enter encryption key',
      'encryptionKeyMinLength': 'Encryption key must be at least 3 characters',
      'encryptionKeyCannotBeEmpty': 'Encryption key cannot be empty',
      'fileNotFound': 'File not found',
      'fileIsEmpty': 'File is empty',
      'encryptedFileIsEmpty': 'Encrypted file is empty',
      'errorEncryptingFile': 'Error encrypting file',
      'errorDecryptingFile': 'Error decrypting file',
      'wrongKeyOrFile': 'Wrong encryption key or file was not encrypted with this key',
      'noEncryptedFileToSave': 'No encrypted file to save',
      'noDecryptedFileToSave': 'No decrypted file to save',
      'errorSavingFile': 'Error saving file',
      'fileNotDecrypted': 'Error: File not decrypted',
      'noEncryptedFileToShare': 'No encrypted file to share',
      'noDecryptedFileToShare': 'No decrypted file to share',
      'encryptedFile': 'Encrypted file',
      'decryptedFile': 'Decrypted file',
      'fileNotReadable': 'File is not readable',
      'invalidImageFormat': 'Invalid image format. Please select a valid image',
      'errorReadingImage': 'Error reading image',
      'errorSavingImage': 'Error saving image',
      'errorEncryptingImage': 'Error encrypting image',
      'errorDecryptingImage': 'Error decrypting image',
      'errorSavingToGallery': 'Error saving image to gallery',
      'noEncryptedImageToSave': 'No encrypted image to save',
      'noDecryptedImageToSave': 'No decrypted image to save',
      'noEncryptedImageToShare': 'No encrypted image to share',
      'noDecryptedImageToShare': 'No decrypted image to share',
      'encryptedImage': 'Encrypted image',
      'decryptedImage': 'Decrypted image',
      'encryptedTextIsEmpty': 'Encrypted text is empty',
      'invalidEncryptedTextFormat': 'Invalid encrypted text format. Please enter correct encrypted text',
      'errorDecrypting': 'Error decrypting',
      'switchToPersian': 'Switch to Persian',
      'switchToEnglish': 'Switch to English',
      'switchToDark': 'Switch to Dark Theme',
      'switchToLight': 'Switch to Light Theme',
      'errorDecryptingText': 'Error decrypting text',
      'speechRecognitionFailed': 'Speech recognition failed. Please check microphone permission and try again',
      'speechRecognitionFailedIOS': 'Speech recognition failed. Please check microphone permission and try again',
      'goToSettingsEnableMicrophone': 'Please go to Settings and enable microphone access',
      'error': 'Error',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get imageEncodingTab =>
      _localizedValues[locale.languageCode]!['imageEncodingTab']!;
  String get textEncoingTab =>
      _localizedValues[locale.languageCode]!['textEncodingTab']!;

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
  String get enterText => _localizedValues[locale.languageCode]!['enterText']!;
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
  String get uploadImageToEncode =>
      _localizedValues[locale.languageCode]!['uploadImageToEncode']!;
  String get uploadImageToDecode =>
      _localizedValues[locale.languageCode]!['uploadImageToDecode']!;
  String get saveToGallery =>
      _localizedValues[locale.languageCode]!['saveToGallery']!;
  String get savedToGallery =>
      _localizedValues[locale.languageCode]!['savedToGallery']!;
  String get share => _localizedValues[locale.languageCode]!['share']!;
  String get encryptedFileSelected =>
      _localizedValues[locale.languageCode]!['encryptedFileSelected']!;
  String get decryptToView =>
      _localizedValues[locale.languageCode]!['decryptToView']!;
  String get encrypted =>
      _localizedValues[locale.languageCode]!['encrypted']!;
  String get pleaseSelectImage =>
      _localizedValues[locale.languageCode]!['pleaseSelectImage']!;
  String get fileEncodingTab =>
      _localizedValues[locale.languageCode]!['fileEncodingTab']!;
  String get uploadFileToEncode =>
      _localizedValues[locale.languageCode]!['uploadFileToEncode']!;
  String get uploadFileToDecode =>
      _localizedValues[locale.languageCode]!['uploadFileToDecode']!;
  String get audioEncodingTab =>
      _localizedValues[locale.languageCode]!['audioEncodingTab']!;
  String get recordAudio =>
      _localizedValues[locale.languageCode]!['recordAudio']!;
  String get stopRecording =>
      _localizedValues[locale.languageCode]!['stopRecording']!;
  String get playAudio =>
      _localizedValues[locale.languageCode]!['playAudio']!;
  String get pauseAudio =>
      _localizedValues[locale.languageCode]!['pauseAudio']!;
  String get recording =>
      _localizedValues[locale.languageCode]!['recording']!;
  String get noAudioRecorded =>
      _localizedValues[locale.languageCode]!['noAudioRecorded']!;
  String get audioRecorded =>
      _localizedValues[locale.languageCode]!['audioRecorded']!;
  String get pleaseRecordAudio =>
      _localizedValues[locale.languageCode]!['pleaseRecordAudio']!;
  String get audioEncrypted =>
      _localizedValues[locale.languageCode]!['audioEncrypted']!;
  String get audioDecrypted =>
      _localizedValues[locale.languageCode]!['audioDecrypted']!;
  String get encryptedAudio =>
      _localizedValues[locale.languageCode]!['encryptedAudio']!;
  String get decryptedAudio =>
      _localizedValues[locale.languageCode]!['decryptedAudio']!;
  String get noEncryptedAudioToSave =>
      _localizedValues[locale.languageCode]!['noEncryptedAudioToSave']!;
  String get noDecryptedAudioToSave =>
      _localizedValues[locale.languageCode]!['noDecryptedAudioToSave']!;
  String get noEncryptedAudioToShare =>
      _localizedValues[locale.languageCode]!['noDecryptedAudioToShare']!;
  String get noDecryptedAudioToShare =>
      _localizedValues[locale.languageCode]!['noDecryptedAudioToShare']!;
  String get errorRecordingAudio =>
      _localizedValues[locale.languageCode]!['errorRecordingAudio']!;
  String get errorPlayingAudio =>
      _localizedValues[locale.languageCode]!['errorPlayingAudio']!;
  String get errorEncryptingAudio =>
      _localizedValues[locale.languageCode]!['errorEncryptingAudio']!;
  String get errorDecryptingAudio =>
      _localizedValues[locale.languageCode]!['errorDecryptingAudio']!;
  String get recordAgain =>
      _localizedValues[locale.languageCode]!['recordAgain']!;
  String get clearRecording =>
      _localizedValues[locale.languageCode]!['clearRecording']!;
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]!['privacyPolicy']!;
  String get termsOfService =>
      _localizedValues[locale.languageCode]!['termsOfService']!;
  String get speechToText =>
      _localizedValues[locale.languageCode]!['speechToText']!;
  String get listening =>
      _localizedValues[locale.languageCode]!['listening']!;
  String get speechNotAvailable =>
      _localizedValues[locale.languageCode]!['speechNotAvailable']!;
  String get speechPermissionDenied =>
      _localizedValues[locale.languageCode]!['speechPermissionDenied']!;
  String get startListening =>
      _localizedValues[locale.languageCode]!['startListening']!;
  String get stopListening =>
      _localizedValues[locale.languageCode]!['stopListening']!;
  String get saveFile =>
      _localizedValues[locale.languageCode]!['saveFile']!;
  String get savedFile =>
      _localizedValues[locale.languageCode]!['savedFile']!;
  String get fileSelected =>
      _localizedValues[locale.languageCode]!['fileSelected']!;
  String get pleaseSelectFile =>
      _localizedValues[locale.languageCode]!['pleaseSelectFile']!;
  String get saveEncryptedFileDialog =>
      _localizedValues[locale.languageCode]!['saveEncryptedFileDialog']!;
  String get saveDecryptedFileDialog =>
      _localizedValues[locale.languageCode]!['saveDecryptedFileDialog']!;
  // Error messages
  String get errorSelectingFile =>
      _localizedValues[locale.languageCode]!['errorSelectingFile']!;
  String get errorSelectingImage =>
      _localizedValues[locale.languageCode]!['errorSelectingImage']!;
  String get pleaseEnterEncryptionKey =>
      _localizedValues[locale.languageCode]!['pleaseEnterEncryptionKey']!;
  String get encryptionKeyMinLength =>
      _localizedValues[locale.languageCode]!['encryptionKeyMinLength']!;
  String get encryptionKeyCannotBeEmpty =>
      _localizedValues[locale.languageCode]!['encryptionKeyCannotBeEmpty']!;
  String get fileNotFound =>
      _localizedValues[locale.languageCode]!['fileNotFound']!;
  String get fileIsEmpty =>
      _localizedValues[locale.languageCode]!['fileIsEmpty']!;
  String get encryptedFileIsEmpty =>
      _localizedValues[locale.languageCode]!['encryptedFileIsEmpty']!;
  String get errorEncryptingFile =>
      _localizedValues[locale.languageCode]!['errorEncryptingFile']!;
  String get errorDecryptingFile =>
      _localizedValues[locale.languageCode]!['errorDecryptingFile']!;
  String get wrongKeyOrFile =>
      _localizedValues[locale.languageCode]!['wrongKeyOrFile']!;
  String get noEncryptedFileToSave =>
      _localizedValues[locale.languageCode]!['noEncryptedFileToSave']!;
  String get noDecryptedFileToSave =>
      _localizedValues[locale.languageCode]!['noDecryptedFileToSave']!;
  String get errorSavingFile =>
      _localizedValues[locale.languageCode]!['errorSavingFile']!;
  String get fileNotDecrypted =>
      _localizedValues[locale.languageCode]!['fileNotDecrypted']!;
  String get noEncryptedFileToShare =>
      _localizedValues[locale.languageCode]!['noEncryptedFileToShare']!;
  String get noDecryptedFileToShare =>
      _localizedValues[locale.languageCode]!['noDecryptedFileToShare']!;
  String get encryptedFile =>
      _localizedValues[locale.languageCode]!['encryptedFile']!;
  String get decryptedFile =>
      _localizedValues[locale.languageCode]!['decryptedFile']!;
  String get fileNotReadable =>
      _localizedValues[locale.languageCode]!['fileNotReadable']!;
  String get invalidImageFormat =>
      _localizedValues[locale.languageCode]!['invalidImageFormat']!;
  String get errorReadingImage =>
      _localizedValues[locale.languageCode]!['errorReadingImage']!;
  String get errorSavingImage =>
      _localizedValues[locale.languageCode]!['errorSavingImage']!;
  String get errorEncryptingImage =>
      _localizedValues[locale.languageCode]!['errorEncryptingImage']!;
  String get errorDecryptingImage =>
      _localizedValues[locale.languageCode]!['errorDecryptingImage']!;
  String get errorSavingToGallery =>
      _localizedValues[locale.languageCode]!['errorSavingToGallery']!;
  String get noEncryptedImageToSave =>
      _localizedValues[locale.languageCode]!['noEncryptedImageToSave']!;
  String get noDecryptedImageToSave =>
      _localizedValues[locale.languageCode]!['noDecryptedImageToSave']!;
  String get noEncryptedImageToShare =>
      _localizedValues[locale.languageCode]!['noEncryptedImageToShare']!;
  String get noDecryptedImageToShare =>
      _localizedValues[locale.languageCode]!['noDecryptedImageToShare']!;
  String get encryptedImage =>
      _localizedValues[locale.languageCode]!['encryptedImage']!;
  String get decryptedImage =>
      _localizedValues[locale.languageCode]!['decryptedImage']!;
  String get encryptedTextIsEmpty =>
      _localizedValues[locale.languageCode]!['encryptedTextIsEmpty']!;
  String get invalidEncryptedTextFormat =>
      _localizedValues[locale.languageCode]!['invalidEncryptedTextFormat']!;
  String get errorDecrypting =>
      _localizedValues[locale.languageCode]!['errorDecrypting']!;
  String get switchToPersian =>
      _localizedValues[locale.languageCode]!['switchToPersian']!;
  String get switchToEnglish =>
      _localizedValues[locale.languageCode]!['switchToEnglish']!;
  String get switchToDark =>
      _localizedValues[locale.languageCode]!['switchToDark']!;
  String get switchToLight =>
      _localizedValues[locale.languageCode]!['switchToLight']!;
  String get errorDecryptingText =>
      _localizedValues[locale.languageCode]!['errorDecryptingText']!;
  String get speechRecognitionFailed =>
      _localizedValues[locale.languageCode]!['speechRecognitionFailed']!;
  String get speechRecognitionFailedIOS =>
      _localizedValues[locale.languageCode]!['speechRecognitionFailedIOS']!;
  String get goToSettingsEnableMicrophone =>
      _localizedValues[locale.languageCode]!['goToSettingsEnableMicrophone']!;
  String get error =>
      _localizedValues[locale.languageCode]!['error']!;
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
