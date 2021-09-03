part of'theme_cubit.dart';

class ThemeState extends Equatable {
  final bool isLight;

  ThemeState(this.isLight);

  @override
  List<Object?> get props => [isLight];

  ThemeState copyWith( {bool? isLight}) {
    return ThemeState(isLight ?? this.isLight);
  }
}
