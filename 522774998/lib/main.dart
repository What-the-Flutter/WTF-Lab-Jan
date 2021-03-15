import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'database/database.dart';
import 'pages/home/home_screen_cubit.dart';
import 'repository/pages_repository.dart';
import 'routes/routes.dart';
import 'theme/theme_model.dart';
import 'theme/theme_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initThemePreferences();
  await DBHelper().initializeDatabase();
  var rep = PagesRepository();
  await rep.setAllPages();
  Bloc.observer = MyBlocObserver();
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: MyApp( rep),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  final PagesRepository pagesRepository;
  MyApp(this.pagesRepository);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (homeScreenContext) {
            return HomePageCubit(repository: pagesRepository);
          }
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
