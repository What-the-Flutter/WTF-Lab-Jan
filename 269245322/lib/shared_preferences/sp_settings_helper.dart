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
  static late final SharedPreferences _prefs;

  const SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() {
    return _sharedPreferencesProvider;
  }

  static Future<void> initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static void changeALigment(int appAligment) {
    String spAligment;
    switch (appAligment) {
      case 0:
        spAligment = aligment.bubbleAlignment.toString();
        break;
      case 1:
        spAligment = aligment.centerDateBubble.toString();
        break;
      default:
        spAligment = aligment.bubbleAlignment.toString();
        break;
    }
    _prefs.setString('aligment', spAligment);
  }

  static void changeTextSize(int size) {
    String spSize;
    switch (size) {
      case 0:
        spSize = textSize.small.toString();
        break;
      case 1:
        spSize = textSize.medium.toString();
        break;
      case 2:
        spSize = textSize.large.toString();
        break;
      default:
        spSize = textSize.medium.toString();
        break;
    }
    _prefs.setString('text_size', spSize);
  }

  static void changeTheme(int appTheme) {
    String spTheme;
    switch (appTheme) {
      case 0:
        spTheme = AppTheme.blueLight.toString();
        break;
      case 1:
        spTheme = AppTheme.blueDark.toString();
        break;
      default:
        spTheme = AppTheme.blueLight.toString();
        break;
    }
    _prefs.setString('theme', spTheme);
  }

  static void changeDatabase(int appDatabase) {
    String spDatabase;
    switch (appDatabase) {
      case 0:
        spDatabase = database.firebase.toString();
        break;
      case 1:
        spDatabase = database.sqLite.toString();
        break;
      default:
        spDatabase = database.firebase.toString();
        break;
    }
    _prefs.setString('database', spDatabase);
  }

  static int getALigment() {
    var spAligment = _prefs.getString('aligment');
    int appAligment;
    switch (spAligment) {
      case 'aligment.bubbleAlignment':
        appAligment = 0;
        break;
      case 'aligment.centerDateBubble':
        appAligment = 1;
        break;
      default:
        appAligment = 0;
        break;
    }
    return appAligment;
  }

  static int getTextSize() {
    var spSize = _prefs.getString('text_size');
    int textSize;
    switch (spSize) {
      case 'textSize.small':
        textSize = 0;
        break;
      case 'textSize.medium':
        textSize = 1;
        break;
      case 'textSize.large':
        textSize = 2;
        break;
      default:
        textSize = 0;
        break;
    }
    return textSize;
  }

  static int getTheme() {
    var spTheme = _prefs.getString('theme');
    int appTheme;
    switch (spTheme) {
      case 'AppTheme.blueLight':
        appTheme = 0;
        break;
      case 'AppTheme.blueDark':
        appTheme = 1;
        break;
      default:
        appTheme = 0;
        break;
    }
    return appTheme;
  }

  static int getDatabase() {
    var spDatabase = _prefs.getString('database');
    int appDatabase;
    switch (spDatabase) {
      case 'database.firebase':
        appDatabase = 0;
        break;
      case 'database.sqLite':
        appDatabase = 1;
        break;
      default:
        appDatabase = 0;
        break;
    }
    return appDatabase;
  }

  static ThemeData getThemeData() {
    ThemeData appTheme;
    _prefs.getString('theme') == 'AppTheme.blueLight'
        ? appTheme = appThemeData[AppTheme.blueLight]!
        : appTheme = appThemeData[AppTheme.blueDark]!;
    return appTheme;
  }

  static void resetSettings() {
    _prefs.setString('theme', 'AppTheme.blueLight');
    _prefs.setString('text_size', 'textSize.small');
    _prefs.setString('aligment', 'aligment.bubbleAlignment');
    _prefs.setString('database', 'database.firebase');
  }
}
