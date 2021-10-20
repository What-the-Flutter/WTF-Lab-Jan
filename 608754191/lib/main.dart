import 'package:animated_splash_screen/animated_splash_screen.dart';
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
import 'pages/settings/settings_page/settings_cubit.dart';
import 'pages/settings/settings_page/settings_page.dart';

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
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(
            preferences: preferences,
          ),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, authState) {
            return BlocProvider(
              create: (context) =>
                  AuthenticationCubit(isAuthenticated: !authState.isAuthenticated)..authenticate(),
              child: MaterialApp(
                title: 'Home Page',
                home: AnimatedSplashScreen(
                  splash: Icons.emoji_people,
                  splashTransition: SplashTransition.rotationTransition,
                  duration: 445,
                  backgroundColor: Colors.yellow,
                  nextScreen: ChatJournalHomePage(),
                ),
                theme: ThemeData.light().copyWith(
                  textTheme: state.textTheme.apply(
                    displayColor: Colors.black,
                    bodyColor: Colors.black,
                    decorationColor: Colors.black,
                  ),
                ),
                darkTheme: ThemeData.dark().copyWith(
                  textTheme: state.textTheme.apply(
                    displayColor: Colors.white,
                    bodyColor: Colors.white,
                    decorationColor: Colors.white,
                  ),
                ),
                themeMode: state.themeMode,
                routes: {
                  '/home_page': (__) => ChatJournalHomePage(),
                  '/add_page': (_) => AddPage.add(),
                  '/timeline_page': (_) => TimelinePage(categories: []),
                  '/settings_page': (_) => SettingsPage(),
                  '/authentication': (_) => AuthorizationPage(),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
