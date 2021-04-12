import 'package:flutter/material.dart';
import 'package:my_chat_journal/auth_screen/auth_screen.dart';

import '../home_screen/home_screen.dart';
import '../messages_screen/screen_message.dart';
import '../screen_creating_page/create_new_page.dart';
import '../search_messages_screen/search_message_screen.dart';
import '../settings_screen/setting_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => HomeWindow(),
        );
      case ScreenMessage.routeName:
        return MaterialPageRoute(
          builder: (context) => ScreenMessage(),
        );
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
      case AuthScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => AuthScreen(),
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
