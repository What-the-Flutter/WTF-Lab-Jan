part of 'create_page_cubit.dart';

@immutable
class CreatePageState {
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

}

