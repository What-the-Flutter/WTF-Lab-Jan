import 'package:chat_journal/pages/main_page/main_page_cubit.dart';
import 'package:chat_journal/services/theme_bloc/theme_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar(state, context),
          body: state.currentPage,
          bottomNavigationBar: _bottomNavbar(context),
        );
      },
    );
  }

  AppBar _appbar(MainState state, context) {
    return AppBar(
      centerTitle: true,
      title: const Text('Home', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(
            Icons.opacity,
          ),
          onPressed: () => BlocProvider.of<ThemeBloc>(context).add(
            ChangeThemeEvent(),
          ),
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 10,
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
