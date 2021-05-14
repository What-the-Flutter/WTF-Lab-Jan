import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtf/UI/main_page/main_page.dart';
import 'package:wtf/model/journals_bloc/journals_bloc.dart';
void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        lazy: false,
        create: (context) => JournalsBloc(),
        child: MainPage(),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedIconTheme: IconThemeData(
              color: Colors.cyan[600],
            ),
            selectedIconTheme: IconThemeData(
              color: Colors.lightBlue[800],
            )),
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        bottomAppBarColor: Colors.lightBlue[800],
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
    ),
  );
}
