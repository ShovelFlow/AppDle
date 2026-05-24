import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String getLanguaje() => _prefs.getString('languaje') ?? 'en';
  static Future<void> setLanguaje(String value) async {
    await _prefs.setString('languaje', value);
  }

  static bool getDarkMode() => _prefs.getBool('darkMode') ?? true;
  static Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('darkMode', value);
  }

  static Color getPrimaryColor() {
    final value = _prefs.getInt('primaryColor');
    return value != null ? Color(value) : Colors.cyanAccent;
  }
  static Future<void> setPrimaryColor(Color color) async {
    await _prefs.setInt('primaryColor', color.toARGB32());
  }
  static Color getCorrectColor() {
    final value = _prefs.getInt('correctColor');
    return value != null ? Color(value) : Colors.green;
  }
  static Future<void> setCorrectColor(Color color) async {
    await _prefs.setInt('correctColor', color.toARGB32());
  }
  static Color getWrongColor() {
    final value = _prefs.getInt('wrongColor');
    return value != null ? Color(value) : Colors.red;
  }
  static Future<void> setWrongColor(Color color) async {
    await _prefs.setInt('wrongColor', color.toARGB32());
  }
  static Color getNeutralColor() {
    final value = _prefs.getInt('neutralColor');
    return value != null ? Color(value) : Colors.orange;
  }
  static Future<void> setNeutralColor(Color color) async {
    await _prefs.setInt('neutralColor', color.toARGB32());
  }
}