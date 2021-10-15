import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/add_page/add_page.dart';
import 'pages/add_page/add_page_cubit.dart';
import 'pages/authorization/authorization_cubit.dart';
import 'pages/authorization/authorization_page.dart';
import 'pages/home_page/home_page.dart';
import 'pages/home_page/home_page_cubit.dart';
import 'pages/navbar_pages/timeline_page/timeline_page.dart';
import 'pages/settings/settings_page/settings_page.dart';
import 'util/shared_preferences/shared_preferences_cubit.dart';
import 'util/theme_inherited/application_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChatJournal(
      preferences: await SharedPreferences.getInstance(),
    ),
  );
}

class ChatJournal extends StatelessWidget {
  final SharedPreferences preferences;

  const ChatJournal({Key? key, required this.preferences}) : super(key: key);

  ThemeMode _themeModeFromString(String? string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddPageCubit(),
        ),
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
        BlocProvider(
          create: (context) => AuthenticationCubit(isAuthenticated: true),
        ),
        BlocProvider<SharedPreferencesCubit>(
          create: (context) => SharedPreferencesCubit(
            _themeModeFromString(
              preferences.getString(
                'themeMode',
              ),
            ),
            true,
            preferences: preferences,
          ),
        ),
      ],
      child: BlocBuilder<SharedPreferencesCubit, SharedPreferencesState>(
        builder: (context, state) => BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, authState) {
            return BlocProvider(
              create: (context) =>
                  AuthenticationCubit(isAuthenticated: !authState.isAuthenticated)..authenticate(),
              child: MaterialApp(
                title: 'Home Page',
                themeMode: state.themeMode,
                theme: lightTheme,
                darkTheme: darkTheme,
                routes: {
                  '/home_page': (__) => ChatJournalHomePage(),
                  '/add_page': (_) => AddPage.add(),
                  '/timeline_page': (_) => TimelinePage(categories: []),
                  '/settings_page': (_) => SettingsPage(),
                  '/authentication': (_) => AuthorizationPage(),
                },
                initialRoute: '/home_page',
              ),
            );
          },
        ),
      ),
    );
  }
}
