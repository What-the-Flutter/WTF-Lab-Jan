import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../modules/page_info.dart';
import '../../utils/database.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void init() async {
    emit(state.copyWith(pages: await DatabaseProvider.fetchPages()));
  }

  void addPage(PageInfo page) {
    final pages = List<PageInfo>.from(state.pages)..add(page);
    DatabaseProvider.insertPage(page);
    final s = state;
    emit(state.copyWith(pages: pages));
    print(s == state);
  }

  void deletePage(int index) {
    final pages = List<PageInfo>.from(state.pages)..removeAt(index);
    DatabaseProvider.deletePage(state.pages[index]);
    emit(state.copyWith(pages: pages));
  }

  void addEvents(List<Event> events, PageInfo page) {
    final pages = List<PageInfo>.from(state.pages);
    final index = pages.indexOf(page);
    for (var event in events) {
      pages[index].events.add(event);
      DatabaseProvider.insertEvent(event);
    }
    pages[index].sortEvents();
    DatabaseProvider.updatePage(pages[index]);
    emit(state.copyWith(pages: pages));
  }

  void updatePage(int index, PageInfo page) {
    final pages = List<PageInfo>.from(state.pages)
      ..[index] = PageInfo.from(page);
    DatabaseProvider.updatePage(page);
    emit(state.copyWith(pages: pages));
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
