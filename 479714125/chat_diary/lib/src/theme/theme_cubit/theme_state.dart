part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final bool isDarkTheme;
  late final ThemeMode currentTheme;

  ThemeState({required this.isDarkTheme}) {
    if (isDarkTheme) {
      currentTheme = ThemeMode.dark;
    } else {
      currentTheme = ThemeMode.light;
    }
  }

  ThemeState copyWith({bool? isDarkTheme}) =>
      ThemeState(isDarkTheme: isDarkTheme ?? this.isDarkTheme);

  @override
  List<Object?> get props => [isDarkTheme];
}
