import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../objects/page_object.dart';
import '../../page_constructor.dart';
import '../../style/custom_theme.dart';
import '../../style/themes.dart';
import 'list_of_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if (_selectedIndex == 1) {
      //   Navigator.pushNamed(context, '/daily');
      // }
    });
  }

  void refreshPage() {
    setState(() {});
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      //????????? убрать Column и ошибка
      body: Column(
        children: [
          PageList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var page = PageObject(title: '', icon: Icons.pool);
          await Navigator.pushNamed(
            context,
            PageConstructor.routeName,
            arguments: page,
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
