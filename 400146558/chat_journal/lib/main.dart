import 'package:chat_journal/models/theme/custom_theme.dart';
import 'package:chat_journal/models/theme/theme_constants.dart';
import 'package:chat_journal/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CustomTheme(themeMode: CustomThemeMode.dark, child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.of(context),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
