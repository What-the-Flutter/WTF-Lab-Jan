import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../navigator/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  final List<Widget> _elements = const [
    QuestionBotButton(),
    ListTile(
      leading: CircleIcon(icon: Icons.collections_bookmark),
      title: Text('Journal'),
      subtitle: Text('No Events. Click to create one.'),
    ),
    ListTile(
      leading: CircleIcon(icon: Icons.menu_book_outlined),
      title: Text('Notes'),
      subtitle: Text('No Events. Click to create one.'),
    ),
    ListTile(
      leading: CircleIcon(icon: Icons.thumb_up_alt_outlined),
      title: Text('Gratitude'),
      subtitle: Text('No Events. Click to create one.'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _floatingActionButton(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _elements.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routs.event);
            },
            child: _element(index),
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
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.invert_colors),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
      title: const Text('Home'),
    );
  }

  Widget _element(int index) {
    return _elements[index];
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
