import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sqflite/sqflite.dart';

import 'database/database.dart';
import 'pages/creating_new_page/creating_new_page_cubit.dart';
import 'pages/home/home_screen_cubit.dart';
import 'pages/messages/screen_messages_cubit.dart';
import 'pages/search/searching_messages_cubit.dart';
import 'pages/settings/settings_page_cubit.dart';
import 'preferences.dart';
import 'repository/icons_repository.dart';
import 'repository/messages_repository.dart';
import 'repository/pages_repository.dart';
import 'routes/routes.dart';
import 'theme/theme_cubit.dart';
import 'theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initialize();
  Bloc.observer = MyBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingPageCubit(
            SettingsPageState(),
          ),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: MaterialApp(
        home: SplashScreen(
          seconds: 5,
          navigateAfterSeconds: MyApp(
            db: await DBHelper.initializeDatabase(),
          ),
          title: Text(
            'Welcome to Chat Journal',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          image: Image(image: AssetImage('images/splashScreen.png')),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: TextStyle(),
          photoSize: 100.0,
          onClick: () => print('Loading app'),
          loaderColor: Colors.orange,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Database db;
  final AppRouter _appRouter = AppRouter();

  MyApp({this.db});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ThemeCubit>(context).initialize();
    final dbHelper = DBHelper(database: db);
    final repositoryMessages = MessagesRepository(dbHelper: dbHelper);
    final repositoryPages = PagesRepository(dbHelper: dbHelper);

    BlocProvider.of<SettingPageCubit>(context).initialize();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeScreenCubit(
            repository: repositoryPages,
          ),
        ),
        BlocProvider(
          create: (context) => ScreenMessagesCubit(
            repository: repositoryMessages,
          ),
        ),
        BlocProvider(
          create: (context) => SearchMessageCubit(
            repository: repositoryMessages,
          ),
        ),
        BlocProvider(
          create: (context) => CreatingNewPageCubit(
            repository: IconsRepository(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final theme = BlocProvider.of<ThemeCubit>(context).state.theme;
          return MaterialApp(
            title: 'Chat Journal',
            theme: theme,
            onGenerateRoute: _appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    print('onCreate -- cubit: ${cubit.runtimeType}');
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    print('onChange -- cubit: ${cubit.runtimeType}, change: $change');
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('onError -- cubit: ${cubit.runtimeType}, error: $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    print('onClose -- cubit: ${cubit.runtimeType}');
  }
}
