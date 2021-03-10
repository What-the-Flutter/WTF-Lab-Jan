import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/creating_categories_screen/creating_categories_screen_bloc.dart';
import 'screens/creating_categories_screen/creating_categories_screen_state.dart';
import 'screens/creating_suggestion_screen/creating_suggestion_screen_bloc.dart';
import 'screens/creating_suggestion_screen/creating_suggestion_screen_state.dart';
import 'screens/event_screen/event_screen_bloc.dart';
import 'screens/event_screen/event_screen_state.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/home_screen/suggestions_bloc.dart';
import 'screens/home_screen/suggestions_state.dart';
import 'screens/setting_screen/settings_screen_bloc.dart';
import 'screens/setting_screen/settings_screen_state.dart';
import 'screens/tab/tab_bloc.dart';
import 'theme/custom_theme.dart';
import 'theme/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SuggestionsBloc>(
          create: (context) => SuggestionsBloc(
            SuggestionsState([], null),
          ),
        ),
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => SettingScreenBloc(SettingsScreenState(
            false,
            false,
          )),
        ),
        BlocProvider(
          create: (context) => CreatingSuggestionScreenBloc(
            CreatingSuggestionScreenState(
              false,
              'assets/images/journal.png',
            ),
          ),
        ),
        BlocProvider(
          create: (context) => CreatingCategoriesScreenBloc(
            CreatingCategoriesScreenState(
              false,
              'assets/images/journal.png',
            ),
          ),
        ),
        BlocProvider(
          create: (context) => EventScreenBloc(
            EventScreenState(
              null,
              [],
              [],
              null,
              null,
              null,
              false,
              false,
              false,
              false,
              false,
              null,
              null,
            ),
          ),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Chat journal',
          themeMode: BlocProvider.of<ThemeBloc>(context).state,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: AnimatedSplashScreen(
            splash: Image.asset(
              'assets/images/splash_screen_icon.png',
            ),
            nextScreen: HomeScreen(
              title: 'Home',
            ),
            splashTransition: SplashTransition.sizeTransition,
          ),
        );
      },
    );
  }
}
