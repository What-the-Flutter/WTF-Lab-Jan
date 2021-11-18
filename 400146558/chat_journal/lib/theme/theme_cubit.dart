import 'package:chat_journal/util/shared_preferences_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState>{
  ThemeCubit(): super(ThemeState(isLight: SharedPreferencesProvider().getThemeMode()));

  void changeTheme(){
    emit(state.copyWith(isLight: !state.isLight));
    SharedPreferencesProvider().addThemeMode(state.isLight);
  }
}