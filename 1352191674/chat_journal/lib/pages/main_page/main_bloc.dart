import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page//home_page.dart';
import 'main_extras.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final _pages = [
    HomePage(),
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
    Container(color: Colors.black),
  ];

  MainBloc() : super(MainState(currentPage: HomePage()));
  @override
  Stream<MainState> mapEventToState(MainEvent event) async*{
    if (event is MainChangePageEvent) {
      yield state.copyWith(currentPage: _pages[event.index], currentIndex: event.index);
    }
  }
}
