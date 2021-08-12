import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class InitState extends AppEvent {
  const InitState();
}

class SwitchThemeEvent extends AppEvent {
  const SwitchThemeEvent();
}
