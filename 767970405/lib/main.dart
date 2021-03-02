import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'logic/home_screen_cubit.dart';
import 'presentation/router/app_router.dart';
import 'presentation/theme/theme_model.dart';

void main() {
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
          create: (homeScreenContext) => HomeScreenCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat Journal',
        theme: Provider
            .of<ThemeModel>(context)
            .currentTheme,
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}


