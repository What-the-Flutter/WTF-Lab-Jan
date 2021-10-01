part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});
  //
  // ThemeState copyWith({bool? isLight}) {
  //   return ThemeState(isLight ?? this.isLight);
  // }

  @override
  List<Object?> get props => [themeMode];
}
