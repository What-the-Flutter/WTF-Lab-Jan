import 'package:flutter_bloc/flutter_bloc.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(
    bool isLight,
  ) : super(
          ThemeState(isLight),
        );
  void changeTheme() {
    emit(
      state.copyWith(isLight: !state.isLight),
    );
  }
}
