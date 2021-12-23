import 'package:flutter/material.dart';
import '../../models/page_model.dart';

class PageState {
  final List<PageModel>? listOfPages;
  final int? selectedPageIndex;
  final PageModel? page;
  final bool? createNewPageChecker;
  final IconData? selectedIcon;
  final PageModel? pageSelectedtoMove;

  PageState copyWith({
    final List<PageModel>? listOfPages,
    final int? selectedPageIndex,
    final PageModel? page,
    final bool? createNewPageChecker,
    final IconData? selectedIcon,
    final PageModel? pageSelectedtoMove,
  }) {
    return PageState(
      listOfPages: listOfPages ?? this.listOfPages,
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
      page: page ?? this.page,
      createNewPageChecker: createNewPageChecker ?? this.createNewPageChecker,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      pageSelectedtoMove: pageSelectedtoMove ?? this.pageSelectedtoMove,
    );
  }

  const PageState({
    this.listOfPages,
    this.selectedPageIndex,
    this.page,
    this.createNewPageChecker,
    this.selectedIcon,
    this.pageSelectedtoMove,
  });
}
