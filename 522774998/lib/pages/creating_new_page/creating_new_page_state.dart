part of 'creating_new_page_cubit.dart';

class CreatingNewPageState extends Equatable {
  final IconData iconButton;
  final IconData selectionIcon;

  CreatingNewPageState({this.iconButton, this.selectionIcon});

  @override
  String toString() {
    return 'ScreenCreatingPageState{selectionIcon: $selectionIcon}';
  }

  @override
  List<Object> get props => [iconButton, selectionIcon];
}
