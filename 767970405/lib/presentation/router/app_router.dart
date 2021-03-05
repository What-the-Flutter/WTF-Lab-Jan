import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/screenMsgCubit/screen_messages_cubit.dart';

import '../../logic/screen_creating_page_cubit.dart';
import '../../repository/icons_repository.dart';
import '../../repository/property_page.dart';
import '../screen/create_new_page.dart';
import '../screen/homeScreen/home_screen.dart';
import '../screen/screen_message.dart';

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
              value: ScreenMessagesCubit(
                repository: args.messages,
                title: args.title,
              ),
              child: ScreenMessage(args)),
        );
      case CreateNewPage.routName:
        return MaterialPageRoute(builder: (context) {
          final args = settings.arguments;
          return BlocProvider.value(
            value: ScreenCreatingPageCubit(repository: IconsRepository()),
            child: CreateNewPage(
              page: args,
            ),
          );
        });
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
