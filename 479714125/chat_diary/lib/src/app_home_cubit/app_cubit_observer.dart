import 'dart:developer';

import 'package:bloc/bloc.dart';

class AppCubitObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType} $change');
  }
}
