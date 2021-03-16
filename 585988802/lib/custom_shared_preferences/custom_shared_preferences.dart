import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreferences {
  static const _keyBubbleAlignment = 'bubbleAlignment';
  static const _keyDateTimeModification = 'DateTimeModification';
  static const _keyFontSize = 'fontSize';
  static const _keyThemeMode = 'themeMode';

  static Future<bool> sharedPrefInitBubbleAlignment() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.getBool(_keyBubbleAlignment) ?? false;
  }

  static Future<bool> sharedPrefInitDateTimeModification() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.getBool(_keyDateTimeModification) ?? false;
  }

  static Future<int> sharedPrefInitFontSize() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.getInt(_keyFontSize) ?? 1;
  }

  static Future<bool> sharedPrefInitTheme() async {
    final pref = await SharedPreferences.getInstance();
    final isCurrentThemeModeDark = await pref.getBool(_keyThemeMode) ?? false;
    return isCurrentThemeModeDark;
  }

  static void sharedPrefChangeBubbleAlignment(bool bubbleAlignment) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyBubbleAlignment, bubbleAlignment);
  }

  static void sharedPrefChangeDateTimeModification(
      bool dateTimeModification) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyDateTimeModification, dateTimeModification);
  }

  static void sharedPrefChangeFontSize(int fontSize) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_keyFontSize, fontSize);
  }

  static void sharedPrefChangeTheme(ThemeMode themeMode) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyThemeMode, themeMode == ThemeMode.dark);
  }

  static void sharedPrefResetSettings() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_keyFontSize, 1);
    await pref.setBool(_keyDateTimeModification, false);
    await pref.setBool(_keyBubbleAlignment, false);
  }

  static void sharedPrefResetTheme() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyThemeMode, false);
  }
}
