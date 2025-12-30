import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  static const String _onboardingKey = 'onboarding_completed';
  bool _isOnboardingCompleted = false;
  bool _isLoading = true;

  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isLoading => _isLoading;
  bool get shouldShowOnboarding => !_isOnboardingCompleted && !_isLoading;

  Future<void> loadOnboardingStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboardingCompleted = prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      _isOnboardingCompleted = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isOnboardingCompleted = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> resetOnboarding() async {
    _isOnboardingCompleted = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, false);
    } catch (e) {
      // Handle error silently
    }
  }
}

