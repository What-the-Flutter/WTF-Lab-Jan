import 'package:flutter/material.dart';

import '../pages/creating_new_page/creating_new_page.dart';
import '../pages/home/home_screen.dart';
import '../pages/messages/screen_messages.dart';
import '../pages/search/searching_message.dart';
import '../pages/settings/settings_page.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
      case ScreenMessages.routeName:
        return MaterialPageRoute(
          builder: (context) => ScreenMessages(),
        );
      case CreateNewPage.routeName:
        return MaterialPageRoute(
          builder: (context) => CreateNewPage(),
        );
      case SearchingPage.routeName:
        return MaterialPageRoute(
          builder: (context) => SearchingPage(),
        );
      case SettingsPage.routeName:
        return MaterialPageRoute(
          builder: (context) => SettingsPage(),
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
