import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import '../../widgets/widgets.dart';
import 'body.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Body(),
    Text(
      'Daily',
      style: optionStyle,
    ),
    Text(
      'Timeline',
      style: optionStyle,
    ),
    Text(
      'Explore',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const Drawer(),
      floatingActionButton: const MyFloatingActionButton(),
      bottomNavigationBar: bottomNavigationBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  Container bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(.2),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(
                icon: LineIcons.bookmark,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.tasks,
                text: 'Daily',
              ),
              GButton(
                icon: LineIcons.map,
                text: 'Timeline',
              ),
              GButton(
                icon: Icons.explore_outlined,
                text: 'Explore',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Diary',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 2,
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () {},
          icon: const Icon(
            LineIcons.adjust,
            color: Colors.black,
          ),
        )
      ],
      leading: Builder(
        builder: (context) {
          return IconButton(
            splashRadius: 20,
            icon: const Icon(LineIcons.bars, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }
}
