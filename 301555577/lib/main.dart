import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './screens/screens.dart';

void main() {
  runApp(const DiaryApp());
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme
            .copyWith(secondary: Colors.white, primary: Colors.black),
        highlightColor: Colors.white10,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const Home(),
    );
  }
}
