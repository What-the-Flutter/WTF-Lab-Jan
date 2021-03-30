import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_journal/data/repository/event_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_provider.dart';
import 'data/repository/icons_repository.dart';
import 'data/repository/messages_repository.dart';
import 'data/repository/pages_repository.dart';
import 'data/repository/theme_repository.dart';
import 'home_screen/home_screen_cubit.dart';
import 'messages_screen/screen_message_cubit.dart';
import 'router/app_router.dart';
import 'screen_creating_page/screen_creating_page_cubit.dart';
import 'search_messages_screen/search_message_screen_cubit.dart';
import 'settings_screen/general_options_cubit.dart';

GetIt getIt = GetIt.instance;

Future<int> loadTheme() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt('theme') ?? 0;
}

Future<void> saveTheme(int index) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme', index);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<PagesAPI>(PagesAPI());
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MessagesRepository>(
          create: (context) => MessagesRepository(
            api: getIt<PagesAPI>(),
          ),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(),
        ),
        RepositoryProvider<IconsRepository>(
          create: (context) => IconsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (homeScreenContext) => HomeScreenCubit(
              repository: PagesRepository(pagesAPI: getIt<PagesAPI>()),
            ),
          ),
          BlocProvider(
            create: (context) => ScreenMessageCubit(
              time: DateTime.now(),
              repository: RepositoryProvider.of<MessagesRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => SearchMessageScreenCubit(
              repository: RepositoryProvider.of<MessagesRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ScreenCreatingPageCubit(
              repository: RepositoryProvider.of<IconsRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => GeneralOptionsCubit(
              themeRepository: ThemeRepository(),
              index: index,
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
