import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/activity_page.dart';
import '../../data/repository/page_repository.dart';
import 'main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  final ActivityPageRepository pageRepository;

  MainPageCubit(this.pageRepository)
      : super(
    MainPageState(
      activityPageList: [],
      isSelected: false,
      isPinned: false,
      selectedPageIndex: 0,
    ),
  );

  void showActivityPages() async {
    final pages = await pageRepository.fetchActivityPageList();
    emit(
      state.copyWith(
        activityPageList: pages,
      ),
    );
  }

  void select(int index) {
    emit(
      state.copyWith(
        selectedPageIndex: index,
        isSelected: true,
      ),
    );
  }

  void unselect() {
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void deleteActivityPage() {
    pageRepository
        .deleteActivityPage(state.activityPageList[state.selectedPageIndex]);
    showActivityPages();
    emit(
      state.copyWith(
        selectedPageIndex: state.selectedPageIndex,
        isSelected: false,
        activityPageList: state.activityPageList,
      ),
    );
  }

  void updateList(List<ActivityPage> pageList) =>
      emit(state.copyWith(activityPageList: pageList));

  void edit() {
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void pinPage() {
    final selectedPage = state.activityPageList[state.selectedPageIndex];
    final pinnedList =
    state.activityPageList.where((element) => element.isPinned).toList();
    final pinnedEventPage = selectedPage.copyWith(
      isPinned: !selectedPage.isPinned,
    );
    if (pinnedEventPage.isPinned) {
      if (pinnedList.length < 3) {
        pageRepository.deleteActivityPage(selectedPage);
        pageRepository.insertActivityPage(pinnedEventPage);
      } else {
        print('More then 3');
      }
    } else {
      pageRepository.updateActivityPage(pinnedEventPage);
    }
    showActivityPages();
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }
}
