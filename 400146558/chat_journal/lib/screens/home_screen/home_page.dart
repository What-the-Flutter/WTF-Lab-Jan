import 'package:chat_journal/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_constants.dart';
import 'package:chat_journal/widgets/home.dart';
import 'package:chat_journal/widgets/navigator_drawer.dart';
import 'package:flutter/material.dart';
import '../../config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  String _title = '';
  bool themeChanged = false;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Text(
      'Daily',
      style: optionStyle,
    ),
    const Text(
      'Timeline',
      style: optionStyle,
    ),
    const Text(
      'Explore',
      style: optionStyle,
    ),
  ];

  _onTap(int index) {
    setState(() {
      _index = index;
      _title = Config.navigationBarItems[_index].label!;
    });
  }

  @override
  void initState() {
    _title = Config.navigationBarItems[_index].label!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigatorDrawer(),
      appBar: _appBar(),
      body: _index == 0
          ? _widgetOptions.elementAt(0)
          : Center(
        child: _widgetOptions.elementAt(_index),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      centerTitle: true,
      title: Text(
        _title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Merriweather',
          fontSize: 28.0,
        ),
      ),
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            themeChanged = !themeChanged;
            BlocProvider.of<ThemeCubit>(context).changeTheme();
          },
          icon: themeChanged
              ? const Icon(
            Icons.wb_incandescent,
            color: themeIconLight,
            size: 30,
          )
              : const Icon(
            Icons.wb_incandescent_outlined,
            color: themeIconDark,
            size: 30,
          ),
        ),
      ],
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _index,
      type: Config.navigationBar.type,
      selectedItemColor: floatingButtonColor,
      unselectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
      backgroundColor: Theme.of(context).primaryColor,
      items: Config.navigationBar.items,
      onTap: _onTap,
    );
  }
}
