part of 'create_page_cubit.dart';

@immutable
class CreatePageState extends Equatable {
  final List<IconData> icons;
  final PageCategoryInfo? editPage;
  late final int? selectedIcon;
  late final bool? isEditMode;

  CreatePageState({
    this.icons = const [],
    this.isEditMode = false,
    this.selectedIcon,
    this.editPage,
  });

  CreatePageState copyWith({
    List<IconData>? icons,
    int? selectedIcon,
    PageCategoryInfo? editPage,
    bool? isEditMode,
  }) {
    return CreatePageState(
      icons: icons ?? this.icons,
      isEditMode: isEditMode ?? isEditMode,
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

