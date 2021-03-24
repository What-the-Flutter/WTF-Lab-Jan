import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_provider.dart';
import 'data/repository/icons_repository.dart';
import 'data/repository/messages_repository.dart';
import 'data/repository/pages_repository.dart';
import 'data/repository/theme_repository.dart';
import 'home_screen/home_screen_cubit.dart';
import 'messages_screen/calendar_cubit.dart';
import 'messages_screen/screen_message_cubit.dart';
import 'router/app_router.dart';
import 'screen_creating_page/screen_creating_page_cubit.dart';
import 'search_messages_screen/search_message_screen_cubit.dart';
import 'settings_screen/general_options_cubit.dart';

Future<int> loadTheme() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt('theme');
}

Future<void> saveTheme(int index) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme', index);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(
    MyApp(
      index: await loadTheme(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final int index;

  MyApp({
    this.index,
  });

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final api = PagesAPI();
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
        BlocProvider(
          create: (context) => GeneralOptionsCubit(
            themeRepository: ThemeRepository(),
            index: index,
          ),
        ),
        BlocProvider(
          create: (context) => CalendarCubit(
            time: DateTime.now(),
          ),
        ),
      ],
      child: BlocBuilder<GeneralOptionsCubit, GeneralOptionsState>(
        builder: (context, state) => MaterialApp(
          title: 'Chat Journal',
          theme: state.currentTheme.appTheme,
          onGenerateRoute: _appRouter.onGenerateRoute,
        ),
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
