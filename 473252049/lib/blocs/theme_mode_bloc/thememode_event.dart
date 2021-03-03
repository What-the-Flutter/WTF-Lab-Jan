part of 'thememode_bloc.dart';

abstract class ThememodeEvent extends Equatable {
  const ThememodeEvent();

  @override
  List<Object> get props => [];
}

class ThememodeChanged extends ThememodeEvent {}
