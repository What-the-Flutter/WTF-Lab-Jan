import 'package:flutter/material.dart';

import 'pages/daily/daily.dart';
import 'pages/home/home.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/daily': (context) => const DailyPage(),
      },
    ),
  );
}
