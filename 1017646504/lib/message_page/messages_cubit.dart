import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../page.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessagesState> {
  late final Database database;

  MessageCubit(MessagesState state) : super(state) {
    _initDb();
  }

  void _initDb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE events(id INTEGER PRIMARY KEY, pageId INTEGER, iconIndex INTEGER, isFavourite INTEGER, description TEXT,creationTime TEXT)',
        );
      },
      version: 1,
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

  void deleteEvents() {
    state.selected
      ..forEach(
        (element) async {
          state.events.remove(element);
          await database.delete(
            'events',
            where: 'id = ?',
            whereArgs: [element.id],
          );
        },
      );
    emit(state.copyWith(selected: {}));
  }

  void addToFavourites() {
    final allFavourites = state.areAllFavourites();
    state.selected
      ..forEach(
        (event) async {
          event.isFavourite = allFavourites ? false : true;
          await database.update(
            'pages',
            event.toMap(),
            where: 'id = ?',
            whereArgs: [event.id],
          );
        },
      );
    emit(state.copyWith(selected: {}));
  }

  void selectEvent(Event event) {
    if (state.isOnSelectionMode) {
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
    }
    emit(state.copyWith());
  }

  Future<void> addEvent(Event event) async {
    await database.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    emit(state.copyWith(events: state.events..insert(0, event)));

  }

  Future<void> editEvent(String description) async {
    state.selected.first.description = description;
    await database.update(
      'pages',
      state.selected.first.toMap(),
      where: 'id = ?',
      whereArgs: [state.selected.first.id],
    );
    setOnEdit(false);
    setSelectionMode(false);
    emit(state.copyWith());
  }

  void selectIcon(int selectedIndex) {
    emit(state.copyWith(selectedIconIndex: selectedIndex));
  }
}
