import 'package:flutter/material.dart';
import 'entity/entities.dart' as entity;
import 'widgets/widgets.dart' as custom;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    entity.Topic.loadTopics();
    return ThemeUpdater(
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: custom.ItemsPage(),
      ),
      theme: entity.Theme.defaultOne(),
    );
  }
}

class ThemeUpdater extends StatefulWidget {
  final Widget child;
  final entity.Theme theme;

  const ThemeUpdater({Key? key, required this.child, required this.theme}) : super(key: key);

  @override
  _ThemeUpdaterState createState() => _ThemeUpdaterState();
}

class _ThemeUpdaterState extends State<ThemeUpdater> {
  @override
  Widget build(BuildContext context) {
    return ThemeInherited(
      child: widget.child,
      preset: widget.theme,
      onEdited: () => setState(() => widget.theme.changeTheme()),
    );
  }
}

class ThemeInherited extends InheritedWidget {
  final entity.Theme preset;
  final Function onEdited;

  ThemeInherited({
    required this.preset,
    required child,
    required this.onEdited,
  }) : super(child: child);

  void changeTheme() {
    onEdited();
  }

  @override
  bool updateShouldNotify(covariant ThemeInherited oldWidget) => true;

  static ThemeInherited? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeInherited>();
}
