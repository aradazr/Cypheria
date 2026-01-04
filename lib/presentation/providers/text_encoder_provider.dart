import 'package:flutter/material.dart';
import '../../domain/repositories/text_encoder_repository.dart';
import '../../data/repositories/text_encoder_repository_impl.dart';
import '../../core/localization/app_localizations.dart';

enum TabType { text, image, file }

class TextEncoderProvider extends ChangeNotifier {
  final TextEncoderRepository _repository = TextEncoderRepositoryImpl();

  String _inputText = '';
  String _key = '';
  String _outputText = '';
  bool _isEncoding = true;
  TabType _currentTab = TabType.text;

  bool _isProcessing = false;
  String? _errorMessage;

  String get inputText => _inputText;
  String get key => _key;
  String get outputText => _outputText;
  bool get isEncoding => _isEncoding;
  bool get isEncodingImage => _currentTab == TabType.image;
  TabType get currentTab => _currentTab;

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

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
    // Cycle through tabs: text -> image -> file -> text
    switch (_currentTab) {
      case TabType.text:
        _currentTab = TabType.image;
        break;
      case TabType.image:
        _currentTab = TabType.file;
        break;
      case TabType.file:
        _currentTab = TabType.text;
        break;
    }
    notifyListeners();
  }

  Future<void> process(BuildContext? context) async {
    if (_inputText.isEmpty) {
      _errorMessage = context != null
          ? _getLocalizedError(context, 'pleaseEnterText')
          : 'Please enter text';
      notifyListeners();
      return;
    }

    if (_key.isEmpty) {
      _errorMessage = context != null
          ? _getLocalizedError(context, 'pleaseEnterKey')
          : 'Please enter key';
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

      _errorMessage = errorMsg;
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
      return 'Error';
    } catch (e) {
      return 'Error';
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
}
