import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../domain/repositories/text_encoder_repository.dart';
import '../../data/repositories/text_encoder_repository_impl.dart';
import '../../core/localization/app_localizations.dart';

enum TabType { text, image, file, audio }

class TextEncoderProvider extends ChangeNotifier {
  final TextEncoderRepository _repository = TextEncoderRepositoryImpl();
  final stt.SpeechToText _speech = stt.SpeechToText();

  String _inputText = '';
  String _key = '';
  String _outputText = '';
  bool _isEncoding = true;
  TabType _currentTab = TabType.text;

  bool _isProcessing = false;
  String? _errorMessage;
  bool _isListening = false;
  bool _speechAvailable = false;
  Locale _locale = const Locale('fa', 'IR');

  String get inputText => _inputText;
  String get key => _key;
  String get outputText => _outputText;
  bool get isEncoding => _isEncoding;
  bool get isEncodingImage => _currentTab == TabType.image;
  TabType get currentTab => _currentTab;

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  bool get isListening => _isListening;
  bool get speechAvailable => _speechAvailable;

  void setLocale(Locale locale) {
    _locale = locale;
  }

  String _getLocalizedString(String key) {
    return AppLocalizations.getString(_locale, key);
  }

  void setInputText(String text) {
    _inputText = text;
    _errorMessage = null;
    notifyListeners();
  }

  void setKey(String key) {
    _key = key;
    _errorMessage = null;
    notifyListeners();
  }

  void toggleMode() {
    _isEncoding = !_isEncoding;
    _errorMessage = null;
    // Swap input and output when toggling
    final String temp = _inputText;
    _inputText = _outputText;
    _outputText = temp;
    notifyListeners();
  }

  void setTab(TabType tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  void toggleTab() {
    // Cycle through tabs: text -> image -> file -> audio -> text
    switch (_currentTab) {
      case TabType.text:
        _currentTab = TabType.image;
        break;
      case TabType.image:
        _currentTab = TabType.file;
        break;
      case TabType.file:
        _currentTab = TabType.audio;
        break;
      case TabType.audio:
        _currentTab = TabType.text;
        break;
    }
    notifyListeners();
  }

  Future<void> process(BuildContext? context) async {
    if (_inputText.isEmpty) {
      _errorMessage = context != null
          ? _getLocalizedError(context, 'pleaseEnterText')
          : _getLocalizedString('pleaseEnterText');
      notifyListeners();
      return;
    }

    if (_key.isEmpty) {
      _errorMessage = context != null
          ? _getLocalizedError(context, 'pleaseEnterKey')
          : _getLocalizedString('pleaseEnterKey');
      notifyListeners();
      return;
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Small delay for UX

      if (_isEncoding) {
        _outputText = _repository.encode(_inputText, _key);
      } else {
        _outputText = _repository.decode(_inputText, _key);
      }

      _errorMessage = null;
    } catch (e) {
      // Extract error message from exception
      String errorMsg = e.toString();
      if (errorMsg.startsWith('Exception: ')) {
        errorMsg = errorMsg.substring(11); // Remove 'Exception: ' prefix
      }

      // Use localized error message
      if (errorMsg.contains('decrypt') || errorMsg.contains('Decrypt')) {
        _errorMessage = _getLocalizedString('errorDecryptingText');
      } else {
        // Try to get localized version if it matches a known key
        _errorMessage = _getLocalizedString(errorMsg) != errorMsg
            ? _getLocalizedString(errorMsg)
            : errorMsg;
      }
      _outputText = '';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  String _getLocalizedError(BuildContext context, String key) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        return key == 'pleaseEnterText'
            ? localizations.pleaseEnterText
            : localizations.pleaseEnterKey;
      }
      return _getLocalizedString('error');
    } catch (e) {
      return _getLocalizedString('error');
    }
  }

  void clearAll() {
    _inputText = '';
    _key = '';
    _outputText = '';
    _errorMessage = null;
    notifyListeners();
  }

  void copyToInput() {
    _inputText = _outputText;
    _outputText = '';
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> initializeSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          debugPrint(
            'DEBUG [TextEncoderProvider.initializeSpeech]: Status: $status',
          );
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            notifyListeners();
          }
        },
        onError: (error) {
          debugPrint('ERROR [TextEncoderProvider.initializeSpeech]: $error');
          _isListening = false;
          _errorMessage = _getLocalizedString('speechNotAvailable');
          notifyListeners();
        },
      );
      debugPrint(
        'DEBUG [TextEncoderProvider.initializeSpeech]: Speech available: $_speechAvailable',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('ERROR [TextEncoderProvider.initializeSpeech]: Exception: $e');
      _speechAvailable = false;
      _errorMessage = _getLocalizedString('speechNotAvailable');
      notifyListeners();
    }
  }

  Future<void> startListening() async {
    debugPrint('DEBUG [TextEncoderProvider.startListening]: Starting...');

    // Always re-initialize to ensure permissions are checked
    debugPrint(
      'DEBUG [TextEncoderProvider.startListening]: Re-initializing speech...',
    );
    await initializeSpeech();

    if (!_speechAvailable) {
      debugPrint(
        'ERROR [TextEncoderProvider.startListening]: Speech not available after initialization',
      );
      _errorMessage = _getLocalizedString('speechNotAvailable');
      notifyListeners();
      return;
    }

    if (_isListening) {
      debugPrint(
        'DEBUG [TextEncoderProvider.startListening]: Already listening, stopping...',
      );
      await stopListening();
      return;
    }

    try {
      debugPrint(
        'DEBUG [TextEncoderProvider.startListening]: Starting speech recognition...',
      );

      // Get available locales
      final locales = await _speech.locales();
      debugPrint(
        'DEBUG [TextEncoderProvider.startListening]: Available locales: ${locales.map((l) => l.localeId).toList()}',
      );

      // Determine which locale to use
      // Android supports Persian (fa_IR), but iOS doesn't
      String preferredLocaleId;
      if (_locale.languageCode == 'fa') {
        if (Platform.isAndroid) {
          // Android supports Persian
          preferredLocaleId = 'fa_IR';
          debugPrint(
            'DEBUG [TextEncoderProvider.startListening]: Android detected, using Persian (fa_IR)',
          );
        } else {
          // iOS doesn't support Persian, use English as fallback
          preferredLocaleId = 'en_US';
          debugPrint(
            'DEBUG [TextEncoderProvider.startListening]: iOS detected, Persian not supported, using English fallback',
          );
        }
      } else {
        preferredLocaleId = 'en_US';
      }

      // Check if preferred locale is available, if not use fallback
      var availableLocale = locales.firstWhere(
        (locale) => locale.localeId == preferredLocaleId,
        orElse: () {
          // Preferred locale not available, use fallback
          debugPrint(
            'DEBUG [TextEncoderProvider.startListening]: Preferred locale ($preferredLocaleId) not available, using fallback',
          );
          if (preferredLocaleId == 'fa_IR') {
            // If Persian was requested but not available, try English
            return locales.firstWhere(
              (locale) => locale.localeId == 'en_US',
              orElse: () => locales.first,
            );
          } else {
            // Use first available locale
            return locales.first;
          }
        },
      );

      debugPrint(
        'DEBUG [TextEncoderProvider.startListening]: Using locale: ${availableLocale.localeId}',
      );

      debugPrint(
        'DEBUG [TextEncoderProvider.startListening]: Using locale: ${availableLocale.localeId}',
      );

      await _speech.listen(
        onResult: (result) {
          debugPrint(
            'DEBUG [TextEncoderProvider.startListening]: Result: ${result.recognizedWords}, final: ${result.finalResult}',
          );
          if (result.finalResult) {
            _inputText = result.recognizedWords;
            _isListening = false;
          } else {
            _inputText = result.recognizedWords;
          }
          notifyListeners();
        },
        localeId: availableLocale.localeId,
        listenMode: stt.ListenMode.dictation,
        pauseFor: const Duration(seconds: 3),
        cancelOnError: false,
        partialResults: true,
      );
      _isListening = true;
      _errorMessage = null;
      debugPrint(
        'DEBUG [TextEncoderProvider.startListening]: Listening started successfully',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('ERROR [TextEncoderProvider.startListening]: Exception: $e');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      _isListening = false;

      // Provide more specific error message
      if (e.toString().contains('ListenFailedException')) {
        if (Platform.isIOS && _locale.languageCode == 'fa') {
          _errorMessage = _getLocalizedString('speechRecognitionFailedIOS');
        } else {
          _errorMessage = _getLocalizedString('speechRecognitionFailed');
        }
      } else {
        _errorMessage = _getLocalizedString('speechPermissionDenied');
      }
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _speech.cancel();
    super.dispose();
  }
}
