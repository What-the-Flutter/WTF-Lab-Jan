import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/screenMessagesCubits/screen_messages_cubit.dart';
import '../logic/screen_creating_page_cubit.dart';
import '../logic/search_messages_cubit.dart';
import '../presentation/screen/create_new_page.dart';
import '../presentation/screen/homeScreen/home_screen.dart';
import '../presentation/screen/screen_message.dart';
import '../presentation/screen/searhing_page.dart';
import '../repository/icons_repository.dart';
import '../repository/messages_repository.dart';
import '../repository/property_page.dart';

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
            child: ScreenMessage(args),
          ),
        );
      case CreateNewPage.routName:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments;
            return BlocProvider.value(
              value: ScreenCreatingPageCubit(repository: IconsRepository()),
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
