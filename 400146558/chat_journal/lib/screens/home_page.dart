import 'package:chat_journal/screens/home/home.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import 'navigator_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  String _title = '';
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
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          _title,
          style: const TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.brush_outlined),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          )
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
        fixedColor: Config.navigationBar.fixedColor,
        items: Config.navigationBar.items,
        onTap: _onTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
