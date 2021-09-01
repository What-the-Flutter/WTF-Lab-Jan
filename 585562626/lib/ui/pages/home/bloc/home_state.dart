import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int index;

  const HomeState({this.index = 0});

  @override
  List<Object?> get props => [index];
}
