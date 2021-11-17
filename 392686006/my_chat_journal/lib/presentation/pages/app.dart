import 'package:flutter/material.dart';

import '../navigator/router.dart';
import '../res/styles.dart';
import 'home/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyChatJournal',
      theme: InheritedCustomTheme.of(context).themeData,
      home: const HomeScreen(),
      routes: routes,
      initialRoute: Routs.home,
      onGenerateRoute: generateRoute,
    );
  }
}
