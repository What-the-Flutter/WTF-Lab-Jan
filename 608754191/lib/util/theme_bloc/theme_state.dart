part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}
