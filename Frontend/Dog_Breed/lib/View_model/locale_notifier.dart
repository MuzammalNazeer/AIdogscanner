import 'package:flutter/material.dart';

import '../Valid/session_controller.dart';

class LocaleNotifier extends ChangeNotifier {
  final SessionController _sessionController = SessionController();
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleNotifier() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    _locale = await _sessionController.getLanguage();
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _sessionController.changeLanguage(locale);
    notifyListeners();
  }
}

