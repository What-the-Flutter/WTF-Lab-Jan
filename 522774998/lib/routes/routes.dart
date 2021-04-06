import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../pages/creating_new_page/creating_new_page.dart';
import '../pages/home/home_screen.dart';
import '../pages/messages/screen_messages.dart';
import '../pages/search/searching_message.dart';
import '../pages/settings/settings_page.dart';
import '../pages/widgets/tabs.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => Tabs(),
        );
      case HomePage.routeName:
        return PageTransition(
          child: HomePage(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case ScreenMessages.routeName:
        return PageTransition(
          child: ScreenMessages(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case CreateNewPage.routeName:
        String title = settings.arguments;
        return PageTransition(
          child: CreateNewPage(title: title),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
      case SearchingPage.routeName:
        return PageTransition(
          child: SearchingPage(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case SettingsPage.routeName:
        return PageTransition(
          child: SettingsPage(),
          type: PageTransitionType.bottomToTop,
          settings: settings,
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
