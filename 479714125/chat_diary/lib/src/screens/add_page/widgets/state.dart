part of 'cubit.dart';

class IconGridViewState extends Equatable {
  final List<IconData> iconsOfPages;
  final int selectedIcon;

  IconGridViewState(this.iconsOfPages, this.selectedIcon);

  @override
  List<Object?> get props => [selectedIcon];

  IconGridViewState copyWith({int? selectedIcon}) =>
      IconGridViewState(iconsOfPages, selectedIcon ?? this.selectedIcon);
}
