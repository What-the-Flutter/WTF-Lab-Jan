import 'package:chat_journal/data/preferences.dart';
import 'package:chat_journal/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _useLightTheme = true;
  final _preferencesAccess = PreferenceData();
  ThemeCubit() : super(Themes.lightTheme);

  void _applyTheme() async {
    final updatedState = _useLightTheme ? Themes.lightTheme : Themes.darkTheme;
    emit(updatedState);
  }

  void initialize() async {
    _useLightTheme = _preferencesAccess.fetchTheme();
    _applyTheme();
  }

  void changeTheme() async {
    _useLightTheme = !_useLightTheme;
    _preferencesAccess.saveTheme(_useLightTheme);
    _applyTheme();
  }
}
