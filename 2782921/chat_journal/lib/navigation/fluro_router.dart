import 'package:chat_journal/screen/home_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:chat_journal/screen/chat_screen.dart';

class fluroRouter {
  static FluroRouter router = FluroRouter();
  static final Handler _homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const MyHomePage(
      title: 'HOME',
    );
  });
  static final Handler _detailedHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return ChatScreen(
      title: params['title'][0],
    );
  });

  static void setupRouter() {
    router.define('/',
        handler: _homeHandler, transitionType: TransitionType.inFromRight);
    router.define('/chat/:title',
        handler: _detailedHandler, transitionType: TransitionType.fadeIn);
  }
}
