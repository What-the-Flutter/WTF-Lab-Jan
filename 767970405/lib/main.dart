import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'data/data_provider.dart';
import 'data/repository/icons_repository.dart';
import 'data/repository/messages_repository.dart';
import 'data/repository/pages_repository.dart';
import 'data/theme/theme_model.dart';
import 'home_screen/home_screen_cubit.dart';
import 'messages_screen/screen_message_cubit.dart';
import 'router/app_router.dart';
import 'screen_creating_page/screen_creating_page_cubit.dart';
import 'search_messages_screen/search_message_screen_cubit.dart';

Future<int> loadTheme() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt('theme');
}

Future<void> saveTheme(ThemeModel themeModel) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme', themeModel.themeType.index);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  final themeModel = ThemeModel(index: await loadTheme());
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (context) => themeModel,
      child: MyApp(db: await PagesAPI.init()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Database db;

  MyApp({
    this.db,
  });

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final api = PagesAPI(database: db);
    final msgRep = MessagesRepository(api: api);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (homeScreenContext) => HomeScreenCubit(
            repository: PagesRepository(pagesAPI: api),
          ),
        ),
        BlocProvider(
          create: (context) => ScreenMessageCubit(
            repository: msgRep,
          ),
        ),
        BlocProvider(
          create: (context) => SearchMessageScreenCubit(
            repository: msgRep,
          ),
        ),
        BlocProvider(
          create: (context) => ScreenCreatingPageCubit(
            repository: IconsRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Chat Journal',
        theme: Provider.of<ThemeModel>(context).currentTheme,
        onGenerateRoute: _appRouter.onGenerateRoute,
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
