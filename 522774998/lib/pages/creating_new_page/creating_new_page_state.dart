part of 'creating_new_page_cubit.dart';

abstract class CreatingNewPageState extends Equatable {
  final int selectionIconIndex;
  final List<ListItemIcon> list;

  CreatingNewPageState({
    this.selectionIconIndex,
    this.list,
  });

  CreatingNewPageState copyWith({
    final List<ListItemIcon> list,
    final int selectionIconIndex,
  });

  @override
  String toString() {
    return 'ScreenCreatingPageState{selectionIconIndex: $selectionIconIndex}';
  }

  @override
  List<Object> get props => [selectionIconIndex, list];
}

class CreatingNewPageStateInitial extends CreatingNewPageState {
  CreatingNewPageStateInitial({
    List<ListItemIcon> list,
    int selectionIconIndex,
  }) : super(
          list: list,
          selectionIconIndex: selectionIconIndex,
  );

  @override
  CreatingNewPageState copyWith({
    List<ListItemIcon> list,
    int selectionIconIndex,
  }) {
    return CreatingNewPageStateInitial(
      list: list ?? this.list,
      selectionIconIndex: selectionIconIndex ?? this.selectionIconIndex,
    );
  }
}

class CreatingNewPageStateWork extends CreatingNewPageState {
  CreatingNewPageStateWork({
    List<ListItemIcon> list,
    int selectionIconIndex,
  }) : super(
          list: list,
          selectionIconIndex: selectionIconIndex,
  );

  @override
  CreatingNewPageState copyWith({
    List<ListItemIcon> list,
    String title,
    int selectionIconIndex,
  }) {
    return CreatingNewPageStateWork(
      list: list ?? this.list,
      selectionIconIndex: selectionIconIndex ?? this.selectionIconIndex,
    );
  }
}
