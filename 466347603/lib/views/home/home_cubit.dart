import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../modules/page_info.dart';
import '../../utils/database_provider.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void init() async {
    final pages = await DatabaseProvider.fetchPages();
    emit(state.copyWith(pages: pages));
  }

  void addPage(PageInfo page) {
    DatabaseProvider.insertPage(page);
    init();
  }

  void deletePage(int index) {
    DatabaseProvider.deletePage(state.pages[index]);
    init();
  }

  void addEvents(List<Event> events, PageInfo page) {
    for (var event in events) {
      event.pageId = page.id;
      DatabaseProvider.updateEvent(event);
    }
  }

  void updatePage(int index, PageInfo page, int id) {
    DatabaseProvider.updatePage(page, id);
    init();
  }

  void updateLastEvent(List lastEvent) {
    state.pages[lastEvent[1] - 1].lastMessage = lastEvent[0];
    emit(state.copyWith(
      lastMessageEvent: lastEvent[0],
      lastMessagePageId: lastEvent[1],
    ));
  }

  void pinPage(int index) {
    final pages = List<PageInfo>.from(state.pages);
    if (pages[index].isPinned) {
      var i = 0;
      while (i < pages.length && pages[i].isPinned) {
        i++;
      }
      pages[index].isPinned = pages[index].isPinned ? false : true;
      DatabaseProvider.updatePage(pages[index]);
      pages.insert(i - 1, PageInfo.from(pages.removeAt(index)));
    } else {
      pages.insert(0, PageInfo.from(pages.removeAt(index)));
      pages[0].isPinned = true;
      DatabaseProvider.updatePage(pages[0]);
    }
    emit(state.copyWith(pages: pages));
  }

  void changeNavBarItem(int? index) {
    emit(state.copyWith(selectedContent: index));
  }
}
