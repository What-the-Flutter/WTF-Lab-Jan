import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  late SharedPreferences _sharedPreferences;

  static final sharedPrefs = MySharedPreferences._();
  MySharedPreferences._();

  Future<void> init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  void setTheme(bool isDark) => _sharedPreferences.setBool('isDark', isDark);

  bool get theme => _sharedPreferences.getBool('isDark') ?? false;
}
