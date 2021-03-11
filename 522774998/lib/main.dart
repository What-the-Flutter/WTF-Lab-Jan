import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'logic/home_screen_cubit.dart';
import 'presentation/theme/theme_model.dart';
import 'repository/pages_repository.dart';
import 'routes/routes.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (homeScreenContext) =>
              HomePageCubit(repository: PagesRepository()),
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