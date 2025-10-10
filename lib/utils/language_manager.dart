import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static const String _languageKey = 'language';
  
  static final LanguageManager _instance = LanguageManager._internal();
  factory LanguageManager() => _instance;
  LanguageManager._internal();

  final StreamController<Locale> _localeController = StreamController<Locale>.broadcast();
  Stream<Locale> get localeStream => _localeController.stream;

  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    _instance._localeController.add(locale);
  }

  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(_languageKey) ?? 'ar';
    return Locale(languageCode);
  }

  static void dispose() {
    _instance._localeController.close();
  }
}