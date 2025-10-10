import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
<<<<<<< HEAD
  Locale _currentLocale = Locale('ar', ''); // اللغة الافتراضية العربية
=======
  Locale _currentLocale = Locale('ar');
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale newLocale) {
<<<<<<< HEAD
    if (newLocale.languageCode != _currentLocale.languageCode) {
      _currentLocale = newLocale;
      notifyListeners();
    }
=======
    _currentLocale = newLocale;
    notifyListeners();
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
  }

  void toggleLanguage() {
    _currentLocale = _currentLocale.languageCode == 'ar' 
<<<<<<< HEAD
        ? Locale('en', '') 
        : Locale('ar', '');
    notifyListeners();
  }

  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';
=======
        ? Locale('en') 
        : Locale('ar');
    notifyListeners();
  }
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
}