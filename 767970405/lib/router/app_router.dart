import 'package:flutter/material.dart';

import '../data/model/model_page.dart';
import '../home_screen/home_screen.dart';
import '../messages_screen/screen_message.dart';
import '../screen_creating_page/create_new_page.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => HomeWindow(),
        );
      case ScreenMessage.routeName:
        final ModelPage args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ScreenMessage(args),
        );
      case CreateNewPage.routName:
        return MaterialPageRoute(builder: (context) {
          final args = settings.arguments;
          return CreateNewPage(
            page: args,
          );
        });
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
