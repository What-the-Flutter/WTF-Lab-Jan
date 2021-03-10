part of 'screen_creating_page_cubit.dart';

class ScreenCreatingPageState extends Equatable {
  final String title;
  final List<LabelModel> list;
  final int selectionIconIndex;
  final IconData iconButton;

  ScreenCreatingPageState({
    this.list,
    this.title,
    this.selectionIconIndex,
    this.iconButton,
  });

  ScreenCreatingPageState copyWith({
    final List<LabelModel> list,
    final String title,
    final int selectionIconIndex,
    final IconData iconButton,
  }) {
    return ScreenCreatingPageState(
      list: list ?? this.list,
      title: title ?? this.title,
      selectionIconIndex: selectionIconIndex ?? this.selectionIconIndex,
      iconButton: iconButton ?? this.iconButton,
    );
  }


  @override
  String toString() {
    return 'ScreenCreatingPageState{title: $title, selectionIconIndex: $selectionIconIndex}';
  }

  @override
  List<Object> get props => [list, title, selectionIconIndex, iconButton];
}
