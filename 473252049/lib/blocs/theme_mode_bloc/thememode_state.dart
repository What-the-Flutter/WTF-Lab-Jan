part of 'thememode_bloc.dart';

abstract class ThememodeState extends Equatable {
  const ThememodeState();

  @override
  List<Object> get props => [];
}

class ThememodeInitial extends ThememodeState {}

class ThememodeSetLightSuccess extends ThememodeState {}

class ThememodeSetDarkSuccess extends ThememodeState {}
