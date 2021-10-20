part of 'shared_preferences_cubit.dart';

class SharedPreferencesState extends Equatable {
  final ThemeMode themeMode;
  final bool bubbleAlignment;

  SharedPreferencesState({
    required this.themeMode,
    required this.bubbleAlignment,
  });

  @override
  List<Object?> get props => [themeMode, bubbleAlignment];
}
