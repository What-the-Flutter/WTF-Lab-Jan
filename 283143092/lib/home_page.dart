import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/home_page_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'category_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc(Screen.home),
      child: BlocBuilder<HomePageBloc, Screen>(
        builder: (context, state) => Scaffold(
          appBar: _appBar(state),
          drawer: _drawer(),
          body: _body(state),
          bottomNavigationBar: _bottomBar(context, state),
        ),
      ),
    );
  }

  AppBar _appBar(Screen screen) {
    return AppBar(
      title: Text(
        ['Home', 'Daily', 'Time Line'][screen.index],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: BlocBuilder<ThemeBloc, bool>(
            builder: (context, state) => IconButton(
              icon: Icon(
                state ? Icons.brightness_3 : Icons.brightness_5,
              ),
              tooltip: state ? 'Dark Theme' : 'Light Theme',
              onPressed: () => context.read<ThemeBloc>().change(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawer() {
    return const Drawer(
      child: Text(
        'Empty Drawer',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 48),
      ),
    );
  }

  Widget _body(Screen screen) {
    switch (screen) {
      case Screen.home:
        return const CategoriesListPage();
      case Screen.daily:
        return _dailyBody();
      case Screen.timeline:
        return _timeLineBody();
      default:
        return ErrorWidget(
          Exception('wrong screen'),
        );
    }
  }

  BottomNavigationBar _bottomBar(BuildContext context, Screen screen) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chrome_reader_mode),
          label: 'Timeline',
        ),
      ],
      currentIndex: screen.index,
      onTap: context.read<HomePageBloc>().setFromIndex,
    );
  }

  // TODO: remove and replace with separate package (like [CategoriesListPage])
  Widget _dailyBody() {
    return const Center(
      child: Text(
        'Daily',
      ),
    );
  }

  // TODO: remove and replace with separate package (like [CategoriesListPage])
  Widget _timeLineBody() {
    return const Center(
      child: Text(
        'Time Line',
      ),
    );
  }
}
