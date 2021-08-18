import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_bloc.dart';
import 'main_extras.dart';

class MainPage extends StatelessWidget {
  final MainBloc _bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          body: state.currentPage,
          bottomNavigationBar: _bottomNavbar(state),
        );
      },
    );
  }

  Widget _bottomNavbar(MainState state) {
    return BottomNavigationBar(
      onTap: (index) => _bloc.add(MainChangePageEvent(index)),
      currentIndex: state.currentIndex ?? 0,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_sharp), label: 'Daily'),
        BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Timeline'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
