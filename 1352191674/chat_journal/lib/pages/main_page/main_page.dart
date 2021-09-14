import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_page_cubit.dart';

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          body: state.currentPage,
          bottomNavigationBar: _bottomNavbar(context),
        );
      },
    );
  }

  Widget _bottomNavbar(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) =>
          BlocProvider.of<MainPageCubit>(context).setSelectedIndex(index),
      currentIndex: BlocProvider.of<MainPageCubit>(context).state.currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_sharp), label: 'Daily'),
        BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Timeline'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
