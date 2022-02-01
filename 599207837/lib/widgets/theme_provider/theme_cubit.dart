import 'package:bloc/bloc.dart';
import '../../database/preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  void changeThemeColor() async {
    final newThemeColor = ThemeColor.values[(state.tColor.index + 1) % 2];
    emit(state.duplicate(tColor: newThemeColor));
    await Preferences.data!.setInt('theme', state.tColor.index);
  }
}
