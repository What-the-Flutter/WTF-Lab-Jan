part of 'label_cubit.dart';

class LabelState implements Equatable {
  final bool isVisible;

  LabelState({this.isVisible});

  @override
  String toString() {
    return 'LabelState{isVisible: $isVisible}';
  }

  @override
  List<Object> get props => [isVisible];

  @override
  bool get stringify => throw UnimplementedError();
}
