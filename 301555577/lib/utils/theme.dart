import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = ThemeData.light().copyWith(
    disabledColor: Colors.white,
    cardColor: Colors.grey.withOpacity(0.3),
    primaryColor: Colors.black,
    backgroundColor: Colors.white,
    primaryColorLight: Colors.white10,
    brightness: Brightness.light,
    iconTheme: const IconThemeData(color: Colors.black),
    primaryIconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Colors.black,
      cursorColor: Colors.black,
    ),
    indicatorColor: Colors.black,
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme()),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.black),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  );

  ThemeData dark = ThemeData.dark().copyWith(
    cardColor: const Color(0xFF353849),
    disabledColor: const Color(0xFF232734),
    primaryColor: Colors.white,
    backgroundColor: const Color(0xFF353849),
    iconTheme: const IconThemeData(color: Colors.white),
    primaryColorLight: const Color(0xFF3F4354),
    scaffoldBackgroundColor: const Color(0xFF3F4354),
    primaryIconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      backgroundColor: const Color(0xFF232734),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    indicatorColor: const Color(0xFF232734),
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme()),
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Colors.white,
      cursorColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF232734),
      foregroundColor: Colors.white,
      elevation: 5,
    ),
  );
  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }
  Future<void> swapTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      prefs.setBool('isDarkTheme', false);
    } else {
      _selectedTheme = dark;
      prefs.setBool('isDarkTheme', true);
    }
    notifyListeners();
  }

  ThemeData get getTheme => _selectedTheme;
}
