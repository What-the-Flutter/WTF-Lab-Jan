abstract class CreateEvent {}

class NewIconEvent extends CreateEvent{
  final int iconIndex;

  NewIconEvent(this.iconIndex);
}

class CreateState {
  final int currentIconIndex;

  CreateState({required this.currentIconIndex});
  CreateState copyWith({int? currentIconIndex}) {
    return CreateState(
      currentIconIndex: currentIconIndex ?? this.currentIconIndex,
    );
  }
}
