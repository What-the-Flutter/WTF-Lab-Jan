import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/creating_new_page/creating_new_page.dart';
import '../pages/creating_new_page/creating_new_page_cubit.dart';
import '../pages/home/home_screen.dart';
import '../pages/messages/screen_messages.dart';
import '../pages/messages/screen_messages_cubit.dart';
import '../pages/search/searching_message.dart';
import '../pages/search/searching_messages_cubit.dart';
import '../repository/icons_repository.dart';
import '../repository/messages_repository.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => StartWindow(),
        );
      case ScreenMessages.routeName:
        final ScreenMessages args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: ScreenMessagesCubit(
              repository: args.repositoryMessages,
              title: args.page.title,
            ),
            child: ScreenMessages(args.page,args.repositoryMessages),
          ),
        );
      case CreateNewPage.routName:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments;
            return BlocProvider.value(
              value: CreatingNewPageCubit(repository: listIcon),
              child: CreateNewPage(
                page: args,
              ),
            );
          },
        );
      case SearchingPage.routeName:
        final MessagesRepository args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider.value(
              value: SearchMessageCubit(
                repository: args,
              ),
              child: SearchingPage(args),
            );
          },
        );
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
