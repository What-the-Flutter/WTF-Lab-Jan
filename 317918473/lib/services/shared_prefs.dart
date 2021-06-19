import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  late SharedPreferences _sharedPreferences;

  static final sharedPrefs = MySharedPreferences._();
  MySharedPreferences._();

  Future<void> init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  void setTheme(bool isDark) => _sharedPreferences.setBool('isDark', isDark);
  bool get theme => _sharedPreferences.getBool('isDark') ?? false;

  void setBubbleAlignment(bool bubbleAlignment) =>
      _sharedPreferences.setBool('isBubbleAlignment', bubbleAlignment);

  bool get isBubbleAlignment =>
      _sharedPreferences.getBool('isBubbleAlignment') ?? false;

  void setCenterDateBubble(bool centerDateBubble) =>
      _sharedPreferences.setBool('isCenterDateBubble', centerDateBubble);

  bool get isCenterDateBubble =>
      _sharedPreferences.getBool('isCenterDateBubble') ?? false;

  void setModifiedDate(bool isModifiedDate) =>
      _sharedPreferences.setBool('isModifiedDate', isModifiedDate);

  bool get isModifiedDate =>
      _sharedPreferences.getBool('isModifiedDate') ?? false;

  void setBiometricAuth(bool biometricAuth) =>
      _sharedPreferences.setBool('isBiometricAuth', biometricAuth);

  bool? get isBiometricAuth => _sharedPreferences.getBool('isBiometricAuth');

  void setDateTime(DateTime dateTime) =>
      _sharedPreferences.setString('dateTime', dateTime.toIso8601String());

  bool get containBiometricAuth =>
      _sharedPreferences.containsKey('isBiometricAuth');

  DateTime get dateTime {
    final dateTime = _sharedPreferences.getString('dateTime') ?? '';
    return dateTime.isNotEmpty ? DateTime.parse(dateTime) : DateTime.now();
  }
}
