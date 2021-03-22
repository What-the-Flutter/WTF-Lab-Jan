part of 'creating_new_page_cubit.dart';

abstract class CreatingNewPageState extends Equatable {
  final IconData iconButton;
  final int selectionIconIndex;
  final List<ListItemIcon> list;

  CreatingNewPageState({
    this.iconButton,
    this.selectionIconIndex,
    this.list,
  });

  CreatingNewPageState copyWith({
    final List<ListItemIcon> list,
    final int selectionIconIndex,
    final IconData iconButton,
  });

  @override
  String toString() {
    return 'ScreenCreatingPageState{selectionIconIndex: $selectionIconIndex}';
  }

  @override
  List<Object> get props => [iconButton, selectionIconIndex, list];
}

class CreatingNewPageStateInitial extends CreatingNewPageState {
  CreatingNewPageStateInitial({
    List<ListItemIcon> list,
    int selectionIconIndex,
    IconData iconButton,
  }) : super(
          list: list,
          selectionIconIndex: selectionIconIndex,
          iconButton: iconButton,
        );

  @override
  CreatingNewPageState copyWith({
    List<ListItemIcon> list,
    int selectionIconIndex,
    IconData iconButton,
  }) {
    return CreatingNewPageStateInitial(
      list: list ?? this.list,
      selectionIconIndex: selectionIconIndex ?? this.selectionIconIndex,
      iconButton: iconButton ?? this.iconButton,
    );
  }
}

class CreatingNewPageStateWork extends CreatingNewPageState {
  CreatingNewPageStateWork({
    List<ListItemIcon> list,
    int selectionIconIndex,
    IconData iconButton,
  }) : super(
          list: list,
          selectionIconIndex: selectionIconIndex,
          iconButton: iconButton,
        );

  @override
  CreatingNewPageState copyWith({
    List<ListItemIcon> list,
    String title,
    int selectionIconIndex,
    IconData iconButton,
  }) {
    return CreatingNewPageStateWork(
      list: list ?? this.list,
      selectionIconIndex: selectionIconIndex ?? this.selectionIconIndex,
      iconButton: iconButton ?? this.iconButton,
    );
  }
}
