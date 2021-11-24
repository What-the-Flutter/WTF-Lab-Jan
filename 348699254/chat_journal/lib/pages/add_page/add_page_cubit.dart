import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/activity_page.dart';
import '../../data/page_repository.dart';
import 'add_page_state.dart';

class PageCubit extends Cubit<PageState> {
  final ActivityPageRepository pageRepository;

  PageCubit(this.pageRepository)
      : super(
    PageState(
      selectedIconIndex: 0,
      pageList: [],
    ),
  );

  void init() {
    emit(
      state.copyWith(
        selectedIconIndex: 0,
        pageList: pageRepository.activityPageList(),
      ),
    );
  }

  void setIconIndex(int index) {
    emit(
      state.copyWith(selectedIconIndex: index),
    );
  }

  void addPage(String pageName, List iconList) {
    final page = ActivityPage(
      id: pageRepository.pageList.length + 1,
      name: pageName,
      icon: iconList[state.selectedIconIndex],
      creationDate: DateTime.now().toString(),
      isPinned: false,
    );
    pageRepository.addActivityPage(page);
  }

  void edit(String pageName, List iconList, int selectedPageIndex) {
    final editedPage = state.pageList[selectedPageIndex].copyWith(
      name: pageName,
      icon: iconList[state.selectedIconIndex],
    );
    pageRepository.deleteActivityPage(state.pageList[selectedPageIndex]);
    pageRepository.insertActivityPage(selectedPageIndex, editedPage);
  }
}