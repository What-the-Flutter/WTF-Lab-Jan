import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/home_page_bloc/homepage_bloc.dart';
import 'blocs/theme_mode_bloc/thememode_bloc.dart';
import 'mocks/mocks.dart';
import 'pages/main_page.dart';

class CubitsObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }
}

void main() {
  final observer = CubitsObserver();
  runApp(MyApp());
}

class ThemeSwitcher extends InheritedWidget {
  @override
  final Widget child;
  final ThememodeBloc thememodeBloc;

  ThemeSwitcher({@required Widget child, this.thememodeBloc})
      : child = BlocProvider(
          create: (context) => thememodeBloc,
          child: child,
        );

  static ThemeSwitcher of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>();
  }

  ThemeMode get themeMode => thememodeBloc.themeMode;

  void switchThemeMode() {
    thememodeBloc.add(ThememodeChanged());
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThememodeBloc thememodeBloc = ThememodeBloc(ThemeMode.light);

  @override
  void dispose() {
    thememodeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      thememodeBloc: thememodeBloc,
      child: BlocBuilder<ThememodeBloc, ThememodeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Char Exp',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: thememodeBloc.themeMode,
            home: BlocProvider<HomepageBloc>(
              create: (context) => HomepageBloc(mockCategories),
              child: MainPage(),
            ),
          );
        },
      ),
    );
  }
}
