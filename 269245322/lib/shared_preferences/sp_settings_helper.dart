import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/app_themes.dart';

enum aligment {
  bubbleAlignment,
  centerDateBubble,
}
enum textSize {
  small,
  medium,
  large,
}
enum database {
  firebase,
  sqLite,
}

class SharedPreferencesProvider {
  static const SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider._createInstance();
  static late final SharedPreferences spInstance;

  const SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() {
    return _sharedPreferencesProvider;
  }

  static Future<void> initialize() async =>
      spInstance = await SharedPreferences.getInstance();

  void changeALigment(int appAligment) {
    spInstance.setInt('aligment', appAligment);
  }

  void changeTextSize(int size) {
    spInstance.setInt('text_size', size);
  }

  void changeTheme(int appTheme) {
    spInstance.setInt('theme', appTheme);
  }

  void changeDatabase(int appDatabase) {
    spInstance.setInt('database', appDatabase);
  }

  int getALigment() {
    try {
      spInstance.getInt('aligment');
    } catch (e) {
      spInstance.setInt('aligment', 0);
    }
    final appAligment = spInstance.getInt('aligment');
    return appAligment!;
  }

  int getTextSize() {
    try {
      spInstance.getInt('text_size');
    } catch (e) {
      spInstance.setInt('text_size', 0);
    }
    final textSize = spInstance.getInt('text_size');
    return textSize!;
  }

  int getTheme() {
    try {
      spInstance.getInt('theme');
    } catch (e) {
      spInstance.setInt('theme', 0);
    }
    final appTheme = spInstance.getInt('theme');
    return appTheme!;
  }

  int getDatabase() {
    try {
      spInstance.getInt('database');
    } catch (e) {
      spInstance.setInt('database', 0);
    }
    final appDatabase = spInstance.getInt('database');
    return appDatabase!;
  }

  ThemeData getThemeData() {
    ThemeData appTheme;
    spInstance.getInt('theme') == 0
        ? appTheme = appThemeData[AppTheme.blueLight]!
        : appTheme = appThemeData[AppTheme.blueDark]!;
    return appTheme;
  }

  void resetSettings() {
    spInstance.setInt('theme', 0);
    spInstance.setInt('text_size', 0);
    spInstance.setInt('aligment', 0);
    spInstance.setInt('database', 0);
  }
}
