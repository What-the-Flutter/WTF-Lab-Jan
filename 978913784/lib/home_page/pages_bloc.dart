import 'package:flutter_bloc/flutter_bloc.dart';

import '../page.dart';
import 'pages_event.dart';

class PagesBloc extends Bloc<PagesEvent, List<JournalPage>> {
  PagesBloc(List<JournalPage> initialState) : super(initialState);

  @override
  Stream<List<JournalPage>> mapEventToState(PagesEvent event) async* {
    if (event is PageAdded) {
      yield* _mapPageAdded(event);
    } else if (event is PagePinned) {
      yield* _mapPagePinned(event);
    } else if (event is PageEdited) {
      yield* _mapPageEdited(event);
    } else if (event is PageDeleted) {
      yield* _mapPageDeleted(event);
    } else if (event is PageUpdated) {
      yield* _mapPageUpdated();
    } else if (event is ForwardAccepted) {
      yield* _mapForwardAccepted(event);
    }
  }

  Stream<List<JournalPage>> _mapPageAdded(PageAdded event) async* {
    final updatedPages = List<JournalPage>.from(state..add(event.page));
    sortList(updatedPages);
    yield updatedPages;
  }

  Stream<List<JournalPage>> _mapPagePinned(PagePinned event) async* {
    final updatedPages = List<JournalPage>.from(state..remove(event.page));
    event.page.isPinned = !event.page.isPinned;
    if (event.page.isPinned) {
      updatedPages.insert(0, event.page);
    } else {
      updatedPages.add(event.page);
    }
    sortList(updatedPages);
    yield updatedPages;
  }

  Stream<List<JournalPage>> _mapPageEdited(PageEdited event) async* {
    event.page.title = event.editedPage.title;
    event.page.icon = event.editedPage.icon;
    final updatedPages = List<JournalPage>.from(state);
    yield updatedPages;
  }

  Stream<List<JournalPage>> _mapPageDeleted(PageDeleted event) async* {
    final updatedPages = List<JournalPage>.from(state..remove(event.page));
    yield updatedPages;
  }

  Stream<List<JournalPage>> _mapPageUpdated() async* {
    final updatedPages = List<JournalPage>.from(state);
    yield sortList(updatedPages);
  }

  Stream<List<JournalPage>> _mapForwardAccepted(ForwardAccepted event) async* {
    List forwardedList = event.forwarded
        .toList()
        ..sort((a, b) => a.creationTime.compareTo(b.creationTime));
    for (var forwardedEvent in forwardedList) {
      event.page.addEvent(forwardedEvent);
    }
    final updatedPages = List<JournalPage>.from(state);
    yield sortList(updatedPages);
  }

  List<JournalPage> sortList(List<JournalPage> list) {
    var pinned = list.where((element) => element.isPinned).toList();
    var unpinned = list.where((element) => !element.isPinned).toList();

    unpinned.sort((a, b) {
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
    });

    return [
      ...pinned,
      ...unpinned,
    ];
  }
}
