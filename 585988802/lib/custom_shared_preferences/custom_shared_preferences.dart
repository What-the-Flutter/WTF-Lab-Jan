import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyBubbleAlignment = 'bubble_alignment';
const _keyDateTimeModification = 'date_time_modification';
const _keyFontSize = 'font_size';
const _keyThemeMode = 'theme_mode';

class CustomSharedPreferences {
  Future<bool> sharedPrefInitBubbleAlignment() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.getBool(_keyBubbleAlignment) ?? false;
  }

  Future<bool> sharedPrefInitDateTimeModification() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.getBool(_keyDateTimeModification) ?? false;
  }

  Future<int> sharedPrefInitFontSize() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.getInt(_keyFontSize) ?? 1;
  }

  Future<bool> sharedPrefInitTheme() async {
    final pref = await SharedPreferences.getInstance();
    final isCurrentThemeModeDark = await pref.getBool(_keyThemeMode) ?? false;
    return isCurrentThemeModeDark;
  }

  void sharedPrefChangeBubbleAlignment(bool bubbleAlignment) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyBubbleAlignment, bubbleAlignment);
  }

  void sharedPrefChangeDateTimeModification(bool dateTimeModification) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyDateTimeModification, dateTimeModification);
  }

  void sharedPrefChangeFontSize(int fontSize) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_keyFontSize, fontSize);
  }

  void sharedPrefChangeTheme(ThemeMode themeMode) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyThemeMode, themeMode == ThemeMode.dark);
  }

  void sharedPrefResetSettings() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_keyFontSize, 1);
    await pref.setBool(_keyDateTimeModification, false);
    await pref.setBool(_keyBubbleAlignment, false);
  }

  void sharedPrefResetTheme() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyThemeMode, false);
  }
}
