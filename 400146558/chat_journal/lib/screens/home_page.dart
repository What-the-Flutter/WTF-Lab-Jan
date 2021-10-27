import 'package:chat_journal/models/theme/custom_theme.dart';
import 'package:chat_journal/models/theme/theme_constants.dart';
import 'package:chat_journal/screens/home/home.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import 'home/navigator_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  String _title = '';
  bool themeChange = false;
  late CustomThemeMode themeMode;

  void _changeTheme(BuildContext buildContext, CustomThemeMode key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

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
      appBar: AppBar(
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
              themeChange = !themeChange;
              if (themeChange == true) {
                themeMode = CustomThemeMode.light;
              } else {
                themeMode = CustomThemeMode.dark;
              }

              _changeTheme(context, themeMode);
            },
            icon: themeChange
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
      ),
      body: _index == 0
          ? _widgetOptions.elementAt(0)
          : Center(
              child: _widgetOptions.elementAt(_index),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: Config.navigationBar.type,
        selectedItemColor: floatingButtonColor,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
        backgroundColor: Theme.of(context).primaryColor,
        items: Config.navigationBar.items,
        onTap: _onTap,
      ),
    );
  }
}
