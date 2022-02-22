import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/firebase_repository.dart';
import '../../database/sqlite_repository.dart';
import '../../models/note_model.dart';
import '../../models/page_model.dart';
import '../../services/entity_repository.dart';
import '../../shared_preferences/sp_settings_helper.dart';
import 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  final SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider();

  late final IRepository<PageModel> dbPageHelper =
      (_sharedPreferencesProvider.getDatabase() == 0)
          ? FireBasePageHelper()
          : SqlitePageRepository();

  PageCubit()
      : super(const PageState(
          selectedIcon: 0,
          selectedPageIndex: 0,
        )) {
    emit(state.copyWith(listOfPages: []));
  }

  void init() async {
    emit(
      state.copyWith(listOfPages: await dbPageHelper.getEntityList(null)),
    );
    emit(
      state.copyWith(pageSelectedtoMove: state.listOfPages!.first),
    );
  }

  void setCurrentPage(PageModel page) {
    final newPage = page;
    emit(state.copyWith(page: newPage));
  }

  void setNewCreateNewPageChecker(bool checkerState) {
    final newCreateNewPageChecker = checkerState;
    emit(state.copyWith(createNewPageChecker: newCreateNewPageChecker));
    if (!checkerState) {
      final previousIcon = state.pageToEdit!.icon;
      emit(state.copyWith(selectedIcon: previousIcon));
    }
  }

  void setPageToEdit(PageModel page) {
    emit(state.copyWith(pageToEdit: page));
  }

  void setNewSelectesIconValue(int icon) {
    final newSelectedIcon = icon;
    emit(state.copyWith(selectedIcon: newSelectedIcon));
  }

  int createId() {
    final id = int.parse(DateTime.now().toString().substring(20, 26));
    return id;
  }

  void addNewPage(String textInpuyControllerText) async {
    final newListOfPages = state.listOfPages!;
    final newPage = PageModel(
      id: createId(),
      title: textInpuyControllerText,
      icon: state.selectedIcon,
      cretionDate: DateTime.now().toString(),
      numOfNotes: 0,
      notesList: [],
      lastModifedDate: DateTime.now().toString(),
    );

    newListOfPages.add(newPage);
    emit(
      state.copyWith(
        listOfPages: newListOfPages,
        selectedIcon: 0,
      ),
    );
    dbPageHelper.insert(newPage, null);
  }

  void editExistingPage(TextEditingController textInpuyControllerText) {
    final newListOfPages = state.listOfPages!;

    final PageModel editedPage;
    editedPage = state.pageToEdit!.copyWith(
        title: textInpuyControllerText.text, icon: state.selectedIcon);
    newListOfPages.remove(state.pageToEdit!);
    newListOfPages.add(editedPage);
    dbPageHelper.update(editedPage, null);
    emit(
      state.copyWith(
        listOfPages: newListOfPages,
        pageToEdit: null,
        selectedIcon: 0,
      ),
    );
  }

  void moveNoteTo(PageModel pageTo, NoteModel note) {
    var pageFromIndex = 0;
    for (var i = 0; i < state.listOfPages!.length; i++) {
      if (state.page!.title == state.listOfPages![i].title) pageFromIndex = i;
    }
    var newListOfPages = state.listOfPages!;
    final pageToIndex = newListOfPages.indexOf(pageTo);
    newListOfPages[pageFromIndex].notesList.remove(note);
    newListOfPages[pageToIndex].notesList.add(note);

    emit(state.copyWith(listOfPages: newListOfPages));
  }

  void setNewPageSelectedToMove(PageModel page) {
    final newPageSelectedToMove = page;
    emit(state.copyWith(pageSelectedtoMove: newPageSelectedToMove));
  }

  PageModel getPageSelectedToMove() {
    return state.pageSelectedtoMove!;
  }

  PageModel getPage() {
    return state.page!;
  }

  List<PageModel> getListOfPages() {
    return state.listOfPages!;
  }
}
