import 'package:bloc/bloc.dart';
import 'package:chat_diary/src/theme/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';
import 'src/app_home_cubit/app_cubit_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cubit = ThemeCubit();
  await cubit.loadTheme();
  BlocOverrides.runZoned(
    () => runApp(BlocProvider<ThemeCubit>(
      create: (context) => cubit,
      child: const App(),
    )),
    blocObserver: AppCubitObserver(),
  );
}
