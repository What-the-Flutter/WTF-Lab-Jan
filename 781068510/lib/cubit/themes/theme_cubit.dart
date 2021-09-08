import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../themes/themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(Themes().lightTheme);

  bool get isDarkMode => state == Themes().darkTheme;

  void changeTheme() {
    emit(state == Themes().lightTheme
        ? Themes().darkTheme
        : Themes().lightTheme);
  }
}
