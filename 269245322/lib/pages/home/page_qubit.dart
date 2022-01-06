import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/note_model.dart';

import '../../models/page_model.dart';
import 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(const PageState());
  //selectedPageIndex useless field
  void initHomePage() =>
      emit(state.copyWith(selectedPageIndex: 0, listOfPages: []));

  void initPageConstructor() {
    emit(state.copyWith(selectedIcon: state.page!.icon));
  }

  void initRadioButtonInPagesWindow(PageModel page) {
    emit(
      state.copyWith(
        pageSelectedtoMove: page,
      ),
    );
  }

  void initEmptyPage() {
    var newPage = PageModel(title: '', icon: Icons.pool);
    emit(state.copyWith(page: newPage));
  }

  void setCurrentPage(PageModel page) {
    var newPage = page;
    emit(state.copyWith(page: newPage));
  }

  void setNewCreateNewPageChecker(bool checkerState) {
    var newCreateNewPageChecker = checkerState;
    emit(state.copyWith(createNewPageChecker: newCreateNewPageChecker));
  }

  String getPageTitle() {
    return state.page!.title;
  }

  void setNewSelectesIconValue(IconData icon) {
    var newSelectedIcon = icon;
    emit(state.copyWith(selectedIcon: newSelectedIcon));
  }

  void addNewPage(String textInpuyControllerText, BuildContext context) {
    var newPage = PageModel(title: '', icon: Icons.pool);

    newPage.title = textInpuyControllerText;
    newPage.icon = state.selectedIcon!;
    newPage.cretionDate = DateTime.now();
    newPage.lastModifedDate = DateTime.now();
    emit(state.copyWith(page: newPage));

    var newListOfPages = state.listOfPages!;

    newListOfPages.add(state.page!);
    emit(state.copyWith(listOfPages: newListOfPages));
    Navigator.pop(context);
  }

  void editExistingPage(String textInpuyControllerText, BuildContext context) {
    print('edit');
    var newListOfPages = state.listOfPages!;
    for (var page in newListOfPages) {
      if (state.page!.title == page.title) {
        page.title = textInpuyControllerText;
        page.icon = state.selectedIcon!;
        emit(state.copyWith(listOfPages: newListOfPages));
        print('edit2');
        break;
      }
    }
    Navigator.pop(context);
  }

  void deletePage(BuildContext context, int index) {
    var newListOfPages = state.listOfPages!;
    newListOfPages.removeAt(index);
    emit(state.copyWith(listOfPages: newListOfPages));
    Navigator.pop(context);
  }

  String cropDateTimeObject(DateTime fullDate) {
    var croppedDate = '';

    croppedDate =
        '${fullDate.day}.${fullDate.month} at ${fullDate.hour}:${fullDate.minute}';
    return croppedDate;
  }

  PageModel getPage() {
    return state.page!;
  }

  List<PageModel> getListOfPages() {
    return state.listOfPages!;
  }

  void moveNoteTo(PageModel pageFrom, PageModel pageTo, NoteModel note) {
    var newListOfPages = state.listOfPages!;
    var pageFromIndex = newListOfPages.indexOf(pageFrom);
    var pageToIndex = newListOfPages.indexOf(pageTo);

    newListOfPages[pageFromIndex].notesList.remove(note);
    newListOfPages[pageToIndex].notesList.add(note);

    emit(state.copyWith(listOfPages: newListOfPages));
  }

  void setNewPageSelectedToMove(PageModel page) {
    print(state.pageSelectedtoMove!.title);
    var newPageSelectedToMove = page;
    emit(state.copyWith(pageSelectedtoMove: newPageSelectedToMove));
    print(state.pageSelectedtoMove!.title);
  }

  PageModel getPageSelectedToMove() {
    return state.pageSelectedtoMove!;
  }
}
