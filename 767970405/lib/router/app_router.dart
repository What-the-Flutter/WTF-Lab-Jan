import 'package:flutter/material.dart';

import '../filter_screen/filter_screen.dart';
import '../messages_screen/screen_message.dart';
import '../screen_creating_page/create_new_page.dart';
import '../search_messages_screen/search_message_screen.dart';
import '../settings_screen/setting_screen.dart';
import '../start_window/start_window.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => StartWindow(),
        );
      case ScreenMessage.routeName:
        return _customAnimation(ScreenMessage());
      case CreateNewPage.routName:
        return MaterialPageRoute(
          builder: (context) => CreateNewPage(),
        );
      case SearchMessageScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SearchMessageScreen(),
        );
      case SettingsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        );
      case GeneralOption.routeName:
        return MaterialPageRoute(
          builder: (context) => GeneralOption(),
        );
      case SecurityOption.routeName:
        return MaterialPageRoute(
          builder: (context) => SecurityOption(),
        );
      case BackgroundImageScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => BackgroundImageScreen(),
        );
      case FilterScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => FilterScreen(),
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }

  Route _customAnimation(Widget child) {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation, secAnimation, child) =>
          ScaleTransition(
            alignment: Alignment.center,
            scale: animation,
            child: child,
          ),
      pageBuilder: (context, animation, secAnimation) => child,
    );
  }
}
