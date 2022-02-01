import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? data;

  static Future<void> lookUpToPreferences() async {
    WidgetsFlutterBinding.ensureInitialized();
    data = await SharedPreferences.getInstance();
  }
}
