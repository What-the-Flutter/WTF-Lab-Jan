import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'pages/app/app.dart';
import 'pages/app/app_cubit.dart';
import 'pages/create_category/create_category_cubit.dart';
import 'pages/home/home_cubit.dart';
import 'pages/settings/settings_cubit.dart';
import 'repository/home_repository.dart';
import 'repository/icons_repository.dart';
import 'theme/theme_cubit.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CreateCategoryCubit(IconsRepository())),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => HomeCubit(HomeRepository())),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => AppCubit()),
      ],
      child: MyApp(),
    ),
  );
}
