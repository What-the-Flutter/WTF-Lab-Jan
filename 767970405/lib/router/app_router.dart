import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/messages_screen/screen_message_cubit.dart';
import 'package:my_chat_journal/search_messages_screen/search_message_screen.dart';

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
        return MaterialPageRoute(
          builder: (context) => ScreenMessage(),
        );
      case CreateNewPage.routName:
        return MaterialPageRoute(builder: (context) {
          return CreateNewPage();
        });
      case SearchMessageScreen.routeName:
        return MaterialPageRoute(builder: (context) {
          return SearchMessageScreen();
        });
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
