import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  bool get isDarkMode => state == darkTheme;

  void changeTheme() {
    emit(state == lightTheme ? darkTheme : lightTheme);
  }
}
