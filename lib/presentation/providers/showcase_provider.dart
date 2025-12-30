import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowcaseProvider extends ChangeNotifier {
  static const String _showcaseKey = 'showcase_completed';
  bool _isShowcaseCompleted = false;
  bool _isLoading = true;
  int _currentShowcaseIndex = 0;

  bool get isShowcaseCompleted => _isShowcaseCompleted;
  bool get isLoading => _isLoading;
  bool get shouldShowShowcase => !_isShowcaseCompleted && !_isLoading;
  int get currentShowcaseIndex => _currentShowcaseIndex;

  Future<void> loadShowcaseStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isShowcaseCompleted = prefs.getBool(_showcaseKey) ?? false;
    } catch (e) {
      _isShowcaseCompleted = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeShowcase() async {
    _isShowcaseCompleted = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_showcaseKey, true);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> resetShowcase() async {
    _isShowcaseCompleted = false;
    _currentShowcaseIndex = 0;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_showcaseKey, false);
    } catch (e) {
      // Handle error silently
    }
  }

  void setCurrentIndex(int index) {
    _currentShowcaseIndex = index;
    notifyListeners();
  }
}

