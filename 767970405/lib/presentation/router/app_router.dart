import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/screen_messages_cubit.dart';
import '../../repository/property_page.dart';
import '../screens/create_new_page.dart';
import '../screens/homeScreen/home_screen.dart';
import '../screens/screen_message.dart';

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
