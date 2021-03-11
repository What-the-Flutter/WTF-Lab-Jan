part of 'input_cubit.dart';

class InputState implements Equatable {
  final Operation mode;
  final Action action;

  InputState({this.action, this.mode});

  @override
  List<Object> get props => [action];

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'InputState{mode: $mode}';
  }
}
