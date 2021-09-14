part of 'create_page_cubit.dart';

class CreatePageState extends Equatable {
  final List<IconData> icons;
  final PageInfo? editPage;
  late final IconData? selectedIcon;

  CreatePageState({
    this.icons = const [],
    this.selectedIcon,
    this.editPage,
  });

  CreatePageState copyWith({
    List<IconData>? icons,
    IconData? selectedIcon,
    PageInfo? editPage,
  }) {
    return CreatePageState(
      icons: icons ?? this.icons,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      editPage: editPage ?? this.editPage,
    );
  }

  @override
  List<Object> get props {
    return [
      if (editPage != null) {editPage},
      if (selectedIcon != null) {selectedIcon},
      icons,
    ];
  }
}
