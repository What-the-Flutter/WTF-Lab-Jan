import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState>{
  ThemeCubit() : super(ThemeState(isLight: true));

  void changeTheme(){
    emit(state.copyWith(isLight: !state.isLight));
  }
}