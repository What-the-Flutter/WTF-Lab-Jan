import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../style/custom_theme.dart';
import '../../style/themes.dart';
import 'page_constructor.dart';
import 'page_qubit.dart';
import 'page_state.dart';
import 'pages_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomePage> {
  final PageCubit _pageCubit = PageCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, PageState>(
      bloc: _pageCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(context),
          body: Column(
            children: [
              PageList(
                pageCubit: _pageCubit,
              ),
            ],
          ),
          floatingActionButton: _floatingActionButton(_pageCubit, context),
          bottomNavigationBar: _bottomNavigationBar(state),
        );
      },
    );
  }
}

void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
  CustomTheme.instanceOf(buildContext).changeTheme(key);
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    title: const Center(child: Text('Home')),
    leading: const IconButton(
      icon: Icon(Icons.menu),
      onPressed: null,
    ),
    actions: <Widget>[
      ToggleSwitch(
        initialLabelIndex: 0,
        cornerRadius: 20.0,
        activeFgColor: Theme.of(context).toggleButtonsTheme.color,
        inactiveBgColor: Theme.of(context).toggleButtonsTheme.selectedColor,
        inactiveFgColor: Theme.of(context).toggleButtonsTheme.fillColor,
        totalSwitches: 2,
        icons: [
          Icons.lightbulb,
          Icons.lightbulb_outline,
        ],
        iconSize: 25.0,
        activeBgColors: [
          [Theme.of(context).toggleButtonsTheme.disabledColor!],
          [Theme.of(context).toggleButtonsTheme.selectedColor!],
        ],
        onToggle: (index) {
          print('switched to: $index');
          (index == 0)
              ? _changeTheme(context, MyThemeKeys.light)
              : _changeTheme(context, MyThemeKeys.dark);
        },
      ),
    ],
    backgroundColor: Theme.of(context).primaryColor,
  );
}

FloatingActionButton _floatingActionButton(
    PageCubit _pageCubit, BuildContext context) {
  return FloatingActionButton(
    onPressed: () => _floatingActionButtonEvent(_pageCubit, context),
    child: const Icon(Icons.add),
  );
}

void _floatingActionButtonEvent(
    PageCubit _pageCubit, BuildContext context) async {
  _pageCubit.setNewCreateNewPageChecker(true);
  await Navigator.pushNamed(
    context,
    PageConstructor.routeName,
    arguments: _pageCubit,
  );
}

BottomNavigationBar _bottomNavigationBar(PageState state) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.close),
        label: 'Test',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.close),
        label: 'Test',
      ),
    ],
    currentIndex: state.selectedPageIndex,
    selectedItemColor: Colors.amber[800],
    onTap: null,
  );
}
