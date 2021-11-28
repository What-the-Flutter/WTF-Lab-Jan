import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/app_cubit_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: AppCubitObserver(),
  );
}
