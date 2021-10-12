import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../database.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(
          HomePageState(
            isSelected: false,
            selectedPageIndex: 0,
            eventPages: [],
          ),
        );

  Stream<List> showPages() async* {
    final pages = await DBProvider.db.eventPagesList();
    emit(
      state.copyWith(
        eventPages: pages,
      ),
    );
    yield pages;
  }

  void select(int i) {
    emit(
      state.copyWith(
        selectedPageIndex: i,
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

  void delete() {
    DBProvider.db.deletePage(state.eventPages[state.selectedPageIndex].id);
    emit(
      state.copyWith(
        selectedPageIndex: state.selectedPageIndex,
        isSelected: false,
      ),
    );
    showPages();
  }

  void edit() {
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void fix() {
    final selectedPage = state.eventPages[state.selectedPageIndex];
    final tempEventPage = selectedPage.copyWith(
      isFixed: !selectedPage.isFixed,
    );
    DBProvider.db.updatePage(tempEventPage);

    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  String latestEventDate() {
    return state.eventPages[state.selectedPageIndex].eventMessages.isEmpty
        ? 'no messages'
        : Jiffy(state
                .eventPages[state.selectedPageIndex].eventMessages.last.date)
            .format('d/M/y h:mm a');
  }
}
