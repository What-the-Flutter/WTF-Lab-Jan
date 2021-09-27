part of 'theme_cubit.dart';

class ThemeState {
  final bool isLight;

  ThemeState(this.isLight);

  ThemeState copyWith({bool? isLight}) {
    return ThemeState(isLight ?? this.isLight);
  }
}
