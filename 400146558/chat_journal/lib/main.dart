import 'package:chat_journal/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow[800],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0XFFFEF9EB),
        ),
      ),
      home: const HomePage(),
    );
  }
}
