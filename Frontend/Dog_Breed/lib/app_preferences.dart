import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _onboardingShownKey = 'onboarding_shown';

  static Future<bool> isOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingShownKey) ?? false;
  }

  static Future<void> setOnboardingShown(bool shown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingShownKey, shown);
  }
}
