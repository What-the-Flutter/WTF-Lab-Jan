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
            pagesList: [],
            pagesFilterMap: {},
            iconsFilterMap: {},
            pagesFilterList: [],
            iconsFilterList: [],
            bookmarkButtonEnable: false,
          ),
        );

  Future<void> initState() async {
    final initNotesList = await _fireBaseNoteHelper.getAllNotes();
    //??????????????????????????????????????????????//
    //final initPagesList = await _fireBasePageHelper.getEntityList(null);
    emit(
      state.copyWith(
        notesList: initNotesList,
        notesListUI: initNotesList,
        //pagesList: initPagesList,
        pagesList: [],
      ),
    );
    _initPagesFilterMap();
    _initIconsFilterMap();
    _initBookMerkedNotesList();
  }

  void _initPagesFilterMap() async {
    final newPagesFilterMap = <String, bool>{};
    for (final page in state.pagesList) {
      newPagesFilterMap[page.title] = true;
    }
    emit(
      state.copyWith(
        pagesFilterMap: newPagesFilterMap,
        pagesFilterList: _initListFromMap(newPagesFilterMap),
      ),
    );
  }

  void updatePagesFilterList(String key) {
    final newPagesFilterMap = state.pagesFilterMap;
    newPagesFilterMap[key] = !newPagesFilterMap[key]!;
    emit(
      state.copyWith(pagesFilterMap: newPagesFilterMap),
    );
  }

  void _initIconsFilterMap() {
    final newIconsFilterMap = <int, bool>{};
    for (final note in state.notesList) {
      newIconsFilterMap[note.icon] = true;
    }
    emit(
      state.copyWith(
        iconsFilterMap: newIconsFilterMap,
        iconsFilterList: _initListFromMap(newIconsFilterMap),
      ),
    );
  }

  void updateiconsFilterList(int key) {
    final newIconsFilterMap = state.iconsFilterMap;
    newIconsFilterMap[key] = !newIconsFilterMap[key]!;
    emit(
      state.copyWith(iconsFilterMap: newIconsFilterMap),
    );
  }

  void _initBookMerkedNotesList() {
    final initBookMerkedNotesList = <NoteModel>[];
    for (final note in state.notesList) {
      if (note.isFavorite == true) initBookMerkedNotesList.add(note);
    }
    emit(
      state.copyWith(bookmarkedNotesList: initBookMerkedNotesList),
    );
    print(initBookMerkedNotesList.length);
  }

  void applyFiltersToNotesList() {
    final newNotesListUI = <NoteModel>[];

    final resultpagesFilterList = <String>[];
    state.pagesFilterMap.forEach((key, value) {
      if (value) resultpagesFilterList.add(key);
    });
    final resultIconsFilterList = <int>[];
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

  List<T> _initListFromMap<T>(Map<T, bool> map) {
    final resultList = <T>[];
    map.forEach((key, value) {
      resultList.add(key);
    });
    return resultList;
  }

  Map<String, bool> getPagesFilterMap() {
    return state.pagesFilterMap;
  }

  List<String> getPagesFilterList() {
    return state.pagesFilterList;
  }

  Map<int, bool> getIconsFilterMap() {
    return state.iconsFilterMap;
  }

  List<int> getIconsFilterList() {
    return state.iconsFilterList;
  }
}
