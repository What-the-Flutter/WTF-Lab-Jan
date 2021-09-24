import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../data/database_access.dart';
import '../data/preferences_access.dart';
import '../entity/page.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessagesState> {
  DatabaseAccess db = DatabaseAccess();

  MessageCubit(MessagesState state) : super(state);

  void initialize(JournalPage page) async {
    final prefs = PreferencesAccess();
    final events = await db.fetchEvents(page.id);
    events.sort((a, b) => b.creationTime.compareTo(a.creationTime));
    emit(
      state.copyWith(
        isDateCentered: prefs.fetchDateCentered(),
        isRightToLeft: prefs.fetchRightToLeft(),
        events: events,
        page: page,
      ),
    );
  }

  void showFavourites(bool showingFavourites) {
    emit(state.copyWith(showingFavourites: showingFavourites));
  }

  void setSelectionMode(bool isOnSelectionMode) {
    if (!isOnSelectionMode) {
      state.selected.clear();
    }
    emit(state.copyWith(isOnSelectionMode: isOnSelectionMode));
  }

  void setOnEdit(bool isOnEdit) {
    emit(state.copyWith(isOnEdit: isOnEdit));
  }

  void setOnSearch(bool isSearching) {
    emit(state.copyWith(isSearching: isSearching));
  }

  void deleteEvents() async {
    state.selected
      ..forEach((event) async {
        state.events.remove(event);
        db.deleteEvent(event);
      });
    emit(state.copyWith(selected: {}));
  }

  void addToFavourites() {
    final allFavourites = state.areAllFavourites();
    state.selected
      ..forEach((event) async {
        event.isFavourite = allFavourites ? false : true;
        db.updateEvent(event);
      });
    emit(state.copyWith(selected: {}));
  }

  void selectEvent(Event event) {
    if (state.selected.contains(event)) {
      state.selected.remove(event);
      if (state.selected.isEmpty) {
        state.isOnSelectionMode = false;
      }
    } else {
      state.selected.add(event);
      if (state.isOnEdit && state.selected.length != 1) {
        state.isOnEdit = false;
      }
    }
    emit(state.copyWith());
  }

  void addEvent(String description) async {
    final event = Event(state.page.id, description, state.selectedIconIndex);
    if (state.isDateSelected) {
      event.creationTime = state.date;
    }
    event.id = await db.insertEvent(event);
    state.events..insert(0, event);
    emit(
      state.copyWith(
          events: state.events..sort((a, b) => b.creationTime.compareTo(a.creationTime))),
    );
  }

  Future<void> addEventFromResource(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    print(appDir);
    final fileName = path.basename(image.path);
    print(fileName);
    final saved = await image.copy('${appDir.path}/$fileName');
    final event = Event.fromResource(state.page.id, state.selectedIconIndex, saved.path);
    if (state.isDateSelected) {
      event.creationTime = state.date;
    }
    event.id = await db.insertEvent(event);
    state.events..insert(0, event);
    emit(
      state.copyWith(
          events: state.events..sort((a, b) => b.creationTime.compareTo(a.creationTime))),
    );
  }

  Future<void> editEvent(String description) async {
    state.selected.first.description = description;
    db.updateEvent(state.selected.first);
    setOnEdit(false);
    setSelectionMode(false);
    emit(state.copyWith());
  }

  void acceptForward(JournalPage page) async {
    List forwardedList = state.selected.toList();
    for (final forwardedEvent in forwardedList) {
      forwardedEvent.pageId = page.id;
      db.updateEvent(forwardedEvent);
    }
    setSelectionMode(false);
    emit(state.copyWith(events: await db.fetchEvents(state.page.id)));
  }

  void selectIcon(int selectedIndex) {
    emit(state.copyWith(selectedIconIndex: selectedIndex));
  }

  void setDate(DateTime? date) {
    final isDateSelected = date != null;
    if (isDateSelected) {
      state.date = date!;
    }
    emit(state.copyWith(isDateSelected: isDateSelected));
  }

  void setCanSelectImage(bool canSelectImage) {
    emit(state.copyWith(canSelectImage: canSelectImage));
  }
}
