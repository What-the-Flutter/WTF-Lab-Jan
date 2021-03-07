part of 'thememode_bloc.dart';

abstract class ThememodeState extends Equatable {
  final ThemeMode themeMode;

  const ThememodeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class ThememodeInitial extends ThememodeState {
  ThememodeInitial(ThemeMode themeMode) : super(themeMode);
}

class ThememodeSetLightSuccess extends ThememodeState {
  ThememodeSetLightSuccess(ThemeMode themeMode) : super(themeMode);
}

class ThememodeSetDarkSuccess extends ThememodeState {
  ThememodeSetDarkSuccess(ThemeMode themeMode) : super(themeMode);
}
