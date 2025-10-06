import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = Locale('ar');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }

  void toggleLanguage() {
    _currentLocale = _currentLocale.languageCode == 'ar' 
        ? Locale('en') 
        : Locale('ar');
    notifyListeners();
  }
}