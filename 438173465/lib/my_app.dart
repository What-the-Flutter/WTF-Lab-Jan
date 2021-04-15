import 'package:flutter/material.dart';

import 'config/custom_theme.dart';
import 'ui/views/home_page/home_page.dart';
import 'ui/views/home_page/screens/event_screen.dart';
import 'ui/views/home_page/screens/events_type_add_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        EventScreen.routeName: (context) => EventScreen(),
        EventTypeAdd.routeName: (context) => EventTypeAdd(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.of(context),
      home: MyHomePage(),
    );
  }
}
