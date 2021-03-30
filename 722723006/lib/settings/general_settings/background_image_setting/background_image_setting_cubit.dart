import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/shared_preferences_provider.dart';
import 'background_image_setting_states.dart';

class BackGroundImageSettingCubit extends Cubit<BackgroundImageSettingStates> {
  BackGroundImageSettingCubit(BackgroundImageSettingStates state)
      : super(state);
  final _prefs = SharedPreferencesProvider();

  void setBackGroundImageSettingState(String backGroundImagePath) {
    _prefs.changeBackGroundImagePath(backGroundImagePath);
    emit(
        state.setBackGroundImagePath(backGroundImagePath: backGroundImagePath));
  }

  void initState() {
    emit(state.setBackGroundImagePath(
        backGroundImagePath: _prefs.fetchBackGroundImagePath()));
  }
}
