import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_screen/home_cubit.dart';
import 'home_screen/home_page.dart';
import 'navigation/fluro_router.dart';
import 'theme/theme_cubit.dart';

void main() {
  FluroRouterCubit.setupRouter();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<FluroRouterCubit>(create: (_) => FluroRouterCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          return MaterialApp(
            home: const MyHomePage(
              title: 'Chat Journal',
            ),
            theme: state,
          );
        },
      ),
    );
  }
}
