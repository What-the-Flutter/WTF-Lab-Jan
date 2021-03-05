part of 'input_cubit.dart';

class InputState implements Equatable {
  final bool isEditable;
  final Action action;

  InputState({
    this.isEditable,
    this.action,
  });

  @override
  List<Object> get props => [isEditable, action];

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'InputState{isEditable: $isEditable}';
  }
}
