import 'package:shared_preferences/shared_preferences.dart';

enum aligment {
  bubbleAlignment,
  centerDateBubble,
}
enum textSize {
  small,
  medium,
  large,
}
enum theme {
  light,
  dark,
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
        spTheme = theme.light.toString();
        break;
      case 1:
        spTheme = theme.dark.toString();
        break;
      default:
        spTheme = theme.light.toString();
        break;
    }
    _prefs.setString('theme', spTheme);
  }

  int getALigment() {
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

  int getTextSize() {
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

  int getTheme() {
    var spTheme = _prefs.getString('theme');
    int appTheme;
    switch (spTheme) {
      case 'theme.light':
        appTheme = 0;
        break;
      case 'theme.dark':
        appTheme = 1;
        break;
      default:
        appTheme = 0;
        break;
    }
    return appTheme;
  }

  static void resetSettings() {
    _prefs.setString('theme', 'theme.light');
    _prefs.setString('text_size', 'textSize.medium');
    _prefs.setString('aligment', 'aligment.bubbleAlignment');
  }
}
