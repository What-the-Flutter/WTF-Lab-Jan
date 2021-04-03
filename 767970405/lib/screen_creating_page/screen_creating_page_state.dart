part of 'screen_creating_page_cubit.dart';

abstract class ScreenCreatingPageState extends Equatable {
  final List<LabelModel> list;
  final int selectionIconIndex;
  final IconData iconButton;

  ScreenCreatingPageState({
    this.list,
    this.selectionIconIndex,
    this.iconButton,
  });

  ScreenCreatingPageState copyWith({
    final List<LabelModel> list,
    final int selectionIconIndex,
    final IconData iconButton,
  });

  @override
  String toString() {
    return 'ScreenCreatingPageState{selectionIconIndex: $selectionIconIndex}';
  }

  @override
  List<Object> get props => [list, selectionIconIndex, iconButton];
}

class ScreenCreatingPageInitial extends ScreenCreatingPageState {
  ScreenCreatingPageInitial({
    List<LabelModel> list,
    int selectionIconIndex,
    IconData iconButton,
  }) : super(
    list: list,
    selectionIconIndex: selectionIconIndex,
    iconButton: iconButton,
  );

  @override
  ScreenCreatingPageState copyWith({
    List<LabelModel> list,
    int selectionIconIndex,
    IconData iconButton,
  }) {
    return ScreenCreatingPageInitial(
      list: list ?? this.list,
      selectionIconIndex: selectionIconIndex ?? this.selectionIconIndex,
      iconButton: iconButton ?? this.iconButton,
    );
  }
}

class ScreenCreatingPageWork extends ScreenCreatingPageState {
  ScreenCreatingPageWork({
    List<LabelModel> list,
    int selectionIconIndex,
    IconData iconButton,
  }) : super(
    list: list,
    selectionIconIndex: selectionIconIndex,
    iconButton: iconButton,
  );

  @override
  ScreenCreatingPageState copyWith({
    List<LabelModel> list,
    String title,
    int selectionIconIndex,
    IconData iconButton,
  }) {
    return ScreenCreatingPageWork(
      list: list ?? this.list,
      selectionIconIndex: selectionIconIndex ?? this.selectionIconIndex,
      iconButton: iconButton ?? this.iconButton,
    );
  }
}
