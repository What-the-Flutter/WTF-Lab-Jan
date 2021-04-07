import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/shared_preferences_provider.dart';

class BackGroundImageSettingCubit extends Cubit<String> {
  BackGroundImageSettingCubit(String state) : super(state);
  final _prefs = SharedPreferencesProvider();

  void setBackGroundImageSettingState(String backGroundImagePath) {
    _prefs.changeBackGroundImagePath(backGroundImagePath);
    emit(backGroundImagePath);
  }

  void initState() => emit(_prefs.fetchBackGroundImagePath());
}
