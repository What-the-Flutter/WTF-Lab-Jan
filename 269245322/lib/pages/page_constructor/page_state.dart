import '../../models/page_model.dart';

class PageState {
  final int selectedIcon;
  final int selectedPageIndex;
  final bool? createNewPageChecker;

  final PageModel? page;
  final PageModel? pageToEdit;
  final PageModel? pageSelectedtoMove;

  final List<PageModel>? listOfPages;

  const PageState({
    this.listOfPages,
    required this.selectedPageIndex,
    this.page,
    this.pageToEdit,
    this.createNewPageChecker,
    required this.selectedIcon,
    this.pageSelectedtoMove,
  });

  PageState copyWith({
    final List<PageModel>? listOfPages,
    final int? selectedPageIndex,
    final PageModel? page,
    final PageModel? pageToEdit,
    final bool? createNewPageChecker,
    final int? selectedIcon,
    final PageModel? pageSelectedtoMove,
  }) {
    return PageState(
      listOfPages: listOfPages ?? this.listOfPages,
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
      page: page ?? this.page,
      pageToEdit: pageToEdit ?? this.pageToEdit,
      createNewPageChecker: createNewPageChecker ?? this.createNewPageChecker,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      pageSelectedtoMove: pageSelectedtoMove ?? this.pageSelectedtoMove,
    );
  }
}
