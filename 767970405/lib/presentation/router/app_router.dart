import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/logic/event_page_cubit.dart';
import 'package:my_chat_journal/logic/screen_messages_cubit.dart';
import 'package:my_chat_journal/repository/property_page.dart';

import '../../create_new_page.dart';
import '../../screen_message.dart';
import '../screens/homeScreen/event_page.dart';
import '../screens/homeScreen/home_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => StartWindow(),
        );
      case ScreenMessage.routeName:
        final PropertyPage args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
              value: ScreenMessagesCubit(messages: args.messages),
              child: ScreenMessage(args)),
        );
      case CreateNewPage.routName:
        return MaterialPageRoute(builder: (_) {
          final int args = settings.arguments;
          if (args == null) {
            return CreateNewPage();
          } else {
            return CreateNewPage(args);
          }
        });
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
