import 'package:chat_journal/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(Themes.lightTheme);

  bool get darkMode => state == Themes.darkTheme;

  void changeTheme() {
    emit(state == Themes.lightTheme ? Themes.darkTheme : Themes.lightTheme);
  }
}
