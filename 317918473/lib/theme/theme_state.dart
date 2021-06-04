part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  final Themes themes;

  const ThemeState(this.themes);

  ThemeState copyWith({
    required final Themes themes,
  });

  @override
  List<Object> get props => [themes];
}

class ThemeChangingInitial extends ThemeState {
  ThemeChangingInitial(Themes themes) : super(themes);

  @override
  ThemeState copyWith({required Themes themes}) {
    return ThemeChangingInitial(themes);
  }
}
