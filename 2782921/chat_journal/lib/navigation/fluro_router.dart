import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../chat_screen/chat_screen.dart';
import '../home_screen/home_page.dart';
import 'package:chat_journal/chat_screen/chat_screen.dart';

class FluroRouterCubit extends Cubit<FluroRouter> {
  static FluroRouter router = FluroRouter();
  static final Handler _homeHandler = Handler(handlerFunc: (
    context,
    params,
  ) {
    return const MyHomePage(
      title: 'HOME',
    );
  });

  static final Handler _detailedHandler = Handler(
    handlerFunc: (
      context,
      Map<String, dynamic> params,
    ) {
      return ChatScreen(
        indexId: params["index"][0],
      );
    },
  );

  FluroRouterCubit() : super(router);

  static void setupRouter() {
    router.define(
      '/',
      handler: _homeHandler,
      transitionType: TransitionType.inFromRight,
    );
    router.define(
      '/chat/:index',
      handler: _detailedHandler,
      transitionType: TransitionType.fadeIn,
    );
  }
}
