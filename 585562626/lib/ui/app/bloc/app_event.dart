import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class SwitchThemeEvent extends AppEvent {
  const SwitchThemeEvent();

  @override
  List<Object?> get props => [];
}
