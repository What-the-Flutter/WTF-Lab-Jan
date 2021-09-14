import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class TabSelectedEvent extends HomeEvent {
  final int index;

  TabSelectedEvent({required this.index});

  @override
  List<Object> get props => [index];
}
