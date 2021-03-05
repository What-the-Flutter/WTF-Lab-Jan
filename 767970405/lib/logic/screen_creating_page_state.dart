part of 'screen_creating_page_cubit.dart';

class ScreenCreatingPageState extends Equatable {
  final IconData iconButton;
  final IconData selectionIcon;

  ScreenCreatingPageState({
    this.iconButton,
    this.selectionIcon,
  });

  @override
  String toString() {
    return 'ScreenCreatingPageState{selectionIcon: $selectionIcon}';
  }

  @override
  List<Object> get props => [iconButton, selectionIcon];
}
