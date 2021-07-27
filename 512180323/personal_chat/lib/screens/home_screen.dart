import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/home_screen_widgets/item_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: pinkBg,
        leading: Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: pinkDecor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              const BoxShadow(
                blurRadius: 1,
                color: Colors.grey,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: blue,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: pinkDecor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 1,
                  color: Colors.grey,
                  offset: Offset(-2, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.wb_sunny_outlined,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          const MyItem(
            title: 'Travel',
            img: AssetImage('assets/images/airplane.png'),
          ),
          const MyItem(
            title: 'Family',
            img: AssetImage('assets/images/family.png'),
          ),
          const MyItem(
            title: 'Sport',
            img: AssetImage('assets/images/sport.png'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red[300],
        child: const Icon(
          Icons.add,
          color: black,
        ),
      ),
    );
  }
}
