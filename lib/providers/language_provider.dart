import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = Locale('ar', ''); // اللغة الافتراضية العربية

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale newLocale) {
    if (newLocale.languageCode != _currentLocale.languageCode) {
      _currentLocale = newLocale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _currentLocale = _currentLocale.languageCode == 'ar' 
        ? Locale('en', '') 
        : Locale('ar', '');
    notifyListeners();
  }

  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';
}