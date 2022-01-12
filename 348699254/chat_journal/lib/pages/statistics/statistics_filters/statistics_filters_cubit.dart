import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/activity_page.dart';
import '../../../data/repository/page_repository.dart';
import 'statistics_filters_state.dart';

class StatisticsFiltersCubit extends Cubit<StatisticsFiltersState> {
  final ActivityPageRepository pageRepository;

  StatisticsFiltersCubit(this.pageRepository)
      : super(
          StatisticsFiltersState(
            pageList: [],
            isSelectedPage: false,
            arePagesIgnored: false,
            selectedPageList: [],
          ),
        );

  void showActivityPages() async {
    final pageList = await pageRepository.fetchActivityPageList();
    pageList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    emit(
      state.copyWith(
        pageList: pageList,
      ),
    );
  }

  void arePagesIgnored() {
    emit(
      state.copyWith(
        arePagesIgnored: !state.arePagesIgnored,
      ),
    );
  }

  void onPageSelected(ActivityPage page) {
    isPageSelected(page) ? _unselectPage(page) : _selectPage(page);
  }

  bool isPageSelected(ActivityPage page) {
    return state.selectedPageList.contains(page);
  }

  void _selectPage(ActivityPage page) {
    final pages = state.selectedPageList;
    pages.add(page);
    emit(
      state.copyWith(
        selectedPageList: pages,
      ),
    );
  }

  void _unselectPage(ActivityPage page) {
    final pages = state.selectedPageList;
    pages.remove(page);
    emit(
      state.copyWith(
        selectedPageList: pages,
      ),
    );
  }

  void clearAllSelectedLists() {
    emit(
      state.copyWith(
        selectedPageList: [],
      ),
    );
  }
}
