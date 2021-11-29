part of 'cubit.dart';

class AddPageScreenState extends Equatable {
  final IconData selectedIcon;

  AddPageScreenState(this.selectedIcon);

  @override
  List<Object?> get props => [selectedIcon];

  AddPageScreenState copyWith({IconData? selectedIcon}) =>
      AddPageScreenState(selectedIcon ?? this.selectedIcon);
}
