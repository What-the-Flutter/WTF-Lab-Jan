import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../modules/page_info.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final List<PageInfo> _initPages = <PageInfo>[
    PageInfo(
      title: 'Journal',
      icon: const Icon(
        Icons.book,
        color: Colors.white,
      ),
    ),
    PageInfo(
      title: 'Notes',
      icon: const Icon(
        Icons.my_library_books,
        color: Colors.white,
      ),
    ),
    PageInfo(
      title: 'Text',
      icon: const Icon(
        Icons.text_fields,
        color: Colors.white,
      ),
    ),
  ];

  HomeCubit() : super(const HomeState());

  void init() {
    emit(state.copyWith(
      pages: state.pages.isEmpty ? _initPages : state.pages,
    ));
  }

  void addPage(PageInfo page) {
    final pages = List<PageInfo>.from(state.pages)..add(page);
    emit(state.copyWith(pages: pages));
  }

  void deletePage(int index) {
    final pages = List<PageInfo>.from(state.pages)..removeAt(index);
    emit(state.copyWith(pages: pages));
  }

  void addEvents(List<Event> events, PageInfo page) {
    final pages = List<PageInfo>.from(state.pages);
    final index = pages.indexOf(page);
    for (var event in events) {
      pages[index].events.add(event);
    }
    pages[index].sortEvents();
    emit(state.copyWith(pages: pages));
  }

  void editPage(int index, PageInfo page) {
    final pages = List<PageInfo>.from(state.pages)
      ..[index] = PageInfo.from(page);
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
      pages.insert(i - 1, PageInfo.from(pages.removeAt(index)));
    } else {
      pages.insert(0, PageInfo.from(pages.removeAt(index)));
      pages[0].isPinned = true;
    }
    emit(state.copyWith(pages: pages));
  }

  void changeNavBarItem(int? index) {
    emit(state.copyWith(selectedContent: index));
  }
}
