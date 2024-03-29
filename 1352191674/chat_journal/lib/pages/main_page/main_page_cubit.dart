import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page/home_page.dart';
import '../timeline_page/timeline_page.dart';

part 'main_page_state.dart';

class MainPageCubit extends Cubit<MainState> {
  final _pages = [
    HomePage(),
    Container(color: Colors.red),
    TimelinePage(),
    Container(color: Colors.green),
  ];

  MainPageCubit() : super(MainState(currentIndex: 0));

  void setSelectedIndex(int index) =>
      emit(state.copyWith(currentPage: _pages[index], currentIndex: index));

  void setWriting(bool isWriting) =>
      emit(state.copyWith(isSearched: isWriting));
}
