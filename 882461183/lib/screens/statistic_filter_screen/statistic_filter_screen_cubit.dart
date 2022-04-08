import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/repository/chat_repository.dart';
import '/models/chat_model.dart';
part 'statistic_filter_screen_state.dart';

class StatisticsFiltersCubit extends Cubit<StatisticsFilterScreenState> {
  final ChatRepository pageRepository;

  StatisticsFiltersCubit(this.pageRepository)
      : super(
          StatisticsFilterScreenState(
            pageList: [],
            isSelectedPage: false,
            arePagesIgnored: false,
            selectedPageList: [],
          ),
        );

  void showActivityPages() async {
    final pageList = await pageRepository.fetchChatList();
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

  void onPageSelected(Chat page) {
    isPageSelected(page) ? _unselectPage(page) : _selectPage(page);
  }

  bool isPageSelected(Chat page) {
    return state.selectedPageList.contains(page);
  }

  void _selectPage(Chat page) {
    final pages = state.selectedPageList;
    pages.add(page);
    emit(
      state.copyWith(
        selectedPageList: pages,
      ),
    );
  }

  void _unselectPage(Chat page) {
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
