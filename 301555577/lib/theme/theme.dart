import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(),
    backgroundColor: Colors.white,
    primaryColor: Colors.black,
    canvasColor: Colors.grey[100],
    primaryIconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme()),
    scaffoldBackgroundColor: const Color(0xFF3F4354),
    primaryColor: Colors.white,
    backgroundColor: const Color(0xFF232734),
    canvasColor: const Color(0xFF353849),
    primaryIconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF232734),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF232734),
      foregroundColor: Colors.white,
    ),
  );

  static void statusBarTheme() {
    if (Get.isDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    } else {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
    }
  }
}
