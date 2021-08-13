import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class InitStateEvent extends AppEvent {
  const InitStateEvent();
}

class SwitchThemeEvent extends AppEvent {
  const SwitchThemeEvent();
}
