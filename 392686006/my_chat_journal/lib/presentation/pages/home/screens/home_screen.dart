import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/event_info.dart';
import '../../../navigator/router.dart';
import '../../../res/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isDarkMode = false;

  final List<EventInfo> events = [
    EventInfo(
      title: 'Journal',
      subtitle: 'No Events. Click to create one.',
      leading: const CircleIcon(icon: Icons.collections_bookmark),
    ),
    EventInfo(
      title: 'Notes',
      subtitle: 'No Events. Click to create one.',
      leading: const CircleIcon(icon: Icons.menu_book_outlined),
    ),
    EventInfo(
      leading: const CircleIcon(icon: Icons.thumb_up_alt_outlined),
      title: 'Gratitude',
      subtitle: 'No Events. Click to create one.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      drawer: const Drawer(),
      floatingActionButton: _floatingActionButton(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _body() {
    final _elements = <Widget>[
      const QuestionBotButton(),
      ...events.map((e) => ListTile(
            title: Text(e.title),
            leading: e.leading,
            subtitle: Text(e.subtitle),
          )),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _elements.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (_elements[index] is ListTile) {
                Navigator.pushNamed(
                  context,
                  Routs.event,
                  arguments: events[index - 1].title,
                );
              }
            },
            child: _elements[index],
          );
        },
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Daily'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Timeline'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
      ],
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      elevation: 8,
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }

  AppBar _appBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: _isDarkMode
              ? const Icon(Icons.invert_colors)
              : const Icon(Icons.invert_colors_outlined),
          onPressed: _changeTheme,
        ),
      ],
      centerTitle: true,
      title: const Text('Home'),
    );
  }

  void _changeTheme() {
    setState(() {
      InheritedCustomTheme.of(context).changeTheme();
      _isDarkMode ^= true;
    });
  }
}

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

class QuestionBotButton extends StatelessWidget {
  const QuestionBotButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.ac_unit,
                size: 32,
              ),
              SizedBox(width: 16),
              Text(
                'Questionnaire Bot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
