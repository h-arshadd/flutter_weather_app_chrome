import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/translations/localization_service.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _tempUnitKey = 'temp_unit_celsius'; // true = Celsius
  static const String _windUnitKey = 'wind_unit_kmh';     // true = km/h

  /// init shared preferences
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true;

  /// save current locale
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// get current locale
  static Locale getCurrentLocal() {
    String? langCode = _sharedPreferences.getString(_currentLocalKey);
    if (langCode == null) {
      return LocalizationService.defaultLanguage;
    }
    return LocalizationService.supportedLanguages[langCode]!;
  }

  /// temperature unit: true = Celsius, false = Fahrenheit
  static Future<void> setTempUnitCelsius(bool isCelsius) =>
      _sharedPreferences.setBool(_tempUnitKey, isCelsius);

  static bool getTempUnitIsCelsius() =>
      _sharedPreferences.getBool(_tempUnitKey) ?? true;

  /// wind speed unit: true = km/h, false = mph
  static Future<void> setWindUnitKmh(bool isKmh) =>
      _sharedPreferences.setBool(_windUnitKey, isKmh);

  static bool getWindUnitIsKmh() =>
      _sharedPreferences.getBool(_windUnitKey) ?? true;

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();
}