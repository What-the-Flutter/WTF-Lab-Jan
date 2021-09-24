import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/database_access.dart';
import '../entity/page.dart';

class PagesCubit extends Cubit<List<JournalPage>> {
  DatabaseAccess db = DatabaseAccess();

  PagesCubit(List<JournalPage> state) : super(state);

  void initialize() async {
    final pages = await db.fetchPages();
    emit(sortPageList(pages));
  }

  void addPage(JournalPage page) async {
    db.insertPage(page);
    final updatedPages = await db.fetchPages();
    emit(sortPageList(updatedPages));
  }

  void pinPage(JournalPage page) async {
    final updatedPages = List<JournalPage>.from(state..remove(page));
    page.isPinned = !page.isPinned;
    db.updatePage(page);
    if (page.isPinned) {
      updatedPages.insert(0, page);
    } else {
      updatedPages.add(page);
    }
    sortPageList(updatedPages);
    emit(updatedPages);
  }

  void editPage(JournalPage page, JournalPage editedPage) async {
    page.title = editedPage.title;
    page.iconIndex = editedPage.iconIndex;
    db.updatePage(page);
    final updatedPages = List<JournalPage>.from(state);
    emit(updatedPages);
  }

  void deletePage(JournalPage page) async {
    final updatedPages = List<JournalPage>.from(state..remove(page));
    db.deletePage(page);
    emit(updatedPages);
  }

  void updatePages() async {
    final updatedPages = await db.fetchPages();
    emit(sortPageList(updatedPages));
  }

  List<JournalPage> sortPageList(List<JournalPage> list) {
    final pinned = list.where((element) => element.isPinned).toList();
    final unpinned = list.where((element) => !element.isPinned).toList();

    unpinned.sort(
      (a, b) {
        final firstEvent = b.lastEvent;
        final secondEvent = a.lastEvent;
        if (firstEvent != null && secondEvent != null) {
          return firstEvent.creationTime.compareTo(secondEvent.creationTime);
        } else if (firstEvent == null && secondEvent == null) {
          return 0;
        } else if (secondEvent == null) {
          return 1;
        } else {
          return -1;
        }
      },
    );

    return [
      ...pinned,
      ...unpinned,
    ];
  }
}
