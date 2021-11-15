import 'package:flutter/material.dart';
import '../pages/event/screens/event_screen.dart';
import '../pages/home/screens/home_screen.dart';

/// Константы для страниц, здесь должны быть перечислены все страницы без исключений
class Routs{
  static const root = '/';
  static const home = '/home';
  static const event = '/event';
}

/// Роуты, в которые не нужно передавать данные, они будут основаны на DI
final routes = <String, WidgetBuilder>{
  // Routs.root: (_) => RootNavigation(),
  Routs.home: (_) => const HomeScreen(),
};

/// Роуты, в которые необходимо передавать данные.
/// Каждый MaterialPageRoute должен содержать параметр [settings], определяющий
/// его назначение.
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routs.event:
      return MaterialPageRoute(
        builder: (_) => EventScreen(title: settings.arguments as String),
        settings: settings,
      );
    default:
      throw Exception("Route with name ${settings.name} doesn't exists");
  }
}