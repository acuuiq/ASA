import 'package:flutter/material.dart';
import 'package:mang_mu/language/app_arabic.dart' as AppLocalizationsAr;
import 'app_arabic.dart';
import 'app_english.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  Map<String, String> _localizedStrings = {};
  
  Future<bool> load() async {
    if (locale.languageCode == 'ar') {
      _localizedStrings = AppLocalizationsAr.keys;
    } else {
      _localizedStrings = AppLocalizationsEn.keys;
    }
    return true;
  }
  
  String translate(String key, [Map<String, String>? params]) {
    String value = _localizedStrings[key] ?? key;
    
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        value = value.replaceAll('{$paramKey}', paramValue);
      });
    }
    
    return value;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}