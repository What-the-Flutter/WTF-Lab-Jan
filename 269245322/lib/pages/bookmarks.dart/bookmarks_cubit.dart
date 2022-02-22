import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/firebase_repository.dart';
import '../../models/note_model.dart';
import 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final FireBaseNoteHelper _fireBaseNoteHelper = FireBaseNoteHelper();
  final FireBasePageHelper _fireBasePageHelper = FireBasePageHelper();

  BookmarksCubit()
      : super(
          BookmarksState(
            notesListUI: [],
            notesList: [],
            bookmarkedNotesList: [],
            pagesFilterMap: {},
            iconsFilterMap: {},
            pagesFilterList: [],
            iconsFilterList: [],
            bookmarkButtonEnable: false,
          ),
        );

  void initState() async {
    final initNotesList = await _fireBaseNoteHelper.getAllNotes();

    emit(
      state.copyWith(notesList: initNotesList, notesListUI: initNotesList),
    );
    _initPagesFilterMap();
    _initiconsFilterMap();
    _initBookMerkedNotesList();
  }

  void _initPagesFilterMap() async {
    final pagesList = await _fireBasePageHelper.getEntityList(null);
    var newPagesFilterMap = <String, bool>{};
    for (final page in pagesList) {
      newPagesFilterMap[page.title] = true;
    }
    emit(
      state.copyWith(
        pagesFilterMap: newPagesFilterMap,
        pagesFilterList: _initListFromMap(newPagesFilterMap) as List<String>,
      ),
    );
  }

  void updatePagesFilterList(String mapKey) {
    var newPagesFilterMap = state.pagesFilterMap;
    newPagesFilterMap[mapKey] = !newPagesFilterMap[mapKey]!;
    emit(
      state.copyWith(pagesFilterMap: newPagesFilterMap),
    );
  }

  void _initiconsFilterMap() {
    var newIconsFilterMap = <int, bool>{};
    for (final note in state.notesList) {
      newIconsFilterMap[note.icon] = true;
    }
    emit(
      state.copyWith(
        iconsFilterMap: newIconsFilterMap,
        iconsFilterList: _initListFromMap(newIconsFilterMap) as List<int>,
      ),
    );
  }

  void updateiconsFilterList(int mapKey) {
    var newIconsFilterMap = state.iconsFilterMap;
    newIconsFilterMap[mapKey] = !newIconsFilterMap[mapKey]!;
    emit(
      state.copyWith(iconsFilterMap: newIconsFilterMap),
    );
  }

  void _initBookMerkedNotesList() {
    var initBookMerkedNotesList = <NoteModel>[];
    for (final note in state.notesList) {
      if (note.isFavorite == true) initBookMerkedNotesList.add(note);
    }
    emit(state.copyWith(bookmarkedNotesList: initBookMerkedNotesList));
    print(initBookMerkedNotesList.length);
  }

  void applyFiltersToNotesList() {
    var newNotesListUI = <NoteModel>[];

    var resultpagesFilterList = <String>[];
    state.pagesFilterMap.forEach((key, value) {
      if (value) resultpagesFilterList.add(key);
    });
    var resultIconsFilterList = <int>[];
    state.iconsFilterMap.forEach((key, value) {
      if (value) resultIconsFilterList.add(key);
    });
    //page & icon filters
    for (final note in state.notesList) {
      if (resultpagesFilterList.contains(note.heading) &&
          resultIconsFilterList.contains(note.icon)) {
        newNotesListUI.add(note);
      }
    }
    print('a ${newNotesListUI.length}');
    emit(state.copyWith(notesListUI: newNotesListUI));
  }

  void bookmarkButtonTap() {
    final newButtonState = !state.bookmarkButtonEnable;
    emit(state.copyWith(bookmarkButtonEnable: newButtonState));
    final List<NoteModel> newNotesListUI;
    (newButtonState == true)
        ? newNotesListUI = state.bookmarkedNotesList
        : newNotesListUI = state.notesList;
    emit(state.copyWith(notesListUI: newNotesListUI));
  }

  bool bookmarkButtonState() {
    return state.bookmarkButtonEnable;
  }

  List<dynamic> _initListFromMap(Map<dynamic, bool> map) {
    var resultList = <dynamic>[];
    switch (map is Map<String, bool>) {
      case true:
        resultList = <String>[];
        map.forEach((key, value) {
          resultList.add(key);
        });
        break;
      case false:
        resultList = <int>[];
        map.forEach((key, value) {
          resultList.add(key);
        });
        break;
      default:
        break;
    }
    return resultList;
  }
}
