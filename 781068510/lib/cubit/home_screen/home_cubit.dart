import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/note_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final List<String> titles = ['Home', 'Daily', 'Timeline', 'Explore'];

  final List<PageCategoryInfo> _initPages = <PageCategoryInfo>[
    PageCategoryInfo(
      title: 'Journal',
      icon: Icons.book,
      ),
    PageCategoryInfo(
      title: 'Notes',
      icon: Icons.my_library_books
      ),
    PageCategoryInfo(
      title: 'Text',
      icon: Icons.text_fields,
    ),
  ];

  HomeCubit() : super(HomeState());

  void init() {
    emit(state.copyWith(
      pages: state.pages.isEmpty ? _initPages : state.pages,
    ));
  }

  void addPage(PageCategoryInfo page) {
    final pages = List<PageCategoryInfo>.from(state.pages)..add(page);
    emit(state.copyWith(pages: pages));
  }

  void deletePage(int index) {
    final pages = List<PageCategoryInfo>.from(state.pages)..removeAt(index);
    emit(state.copyWith(pages: pages));
  }

  void addEvents(List<Note> events, PageCategoryInfo page) {
    final pages = List<PageCategoryInfo>.from(state.pages);
    final index = pages.indexOf(page);
    for (var event in events) {
      pages[index].note.add(event);
    }
    pages[index].sortEvents();
    emit(state.copyWith(pages: pages));
  }

  void editPage(int index, PageCategoryInfo page) {
    final pages = List<PageCategoryInfo>.from(state.pages)
      ..[index] = PageCategoryInfo.from(page);
    emit(state.copyWith(pages: pages));
  }

  void pinPage(int index) {
    final pages = List<PageCategoryInfo>.from(state.pages);
    if (pages[index].isPinned) {
      var i = 0;
      while (i < pages.length && pages[i].isPinned) {
        i++;
      }
      pages[index].isPinned = pages[index].isPinned ? false : true;
      pages.insert(i - 1, PageCategoryInfo.from(pages.removeAt(index)));
    } else {
      pages.insert(0, PageCategoryInfo.from(pages.removeAt(index)));
      pages[0].isPinned = true;
    }
    emit(state.copyWith(pages: pages));
  }

  void setNavBarItem(int? index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
