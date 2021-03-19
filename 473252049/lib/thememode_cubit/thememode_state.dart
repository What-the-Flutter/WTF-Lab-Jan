part of 'thememode_cubit.dart';

class ThememodeState extends Equatable {
  final ThemeMode themeMode;

  ThememodeState({@required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}
