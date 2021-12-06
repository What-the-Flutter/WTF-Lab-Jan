import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme.dart';
class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(light);

  bool get isDarkMode => state == dark;

  void changeTheme() {
    emit(state == light ? dark : light);
  }
}