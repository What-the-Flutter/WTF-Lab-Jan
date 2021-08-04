import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category.dart';
import 'category_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Notes',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(
        title: 'Home',
        categories: [
          Category('Sports', Colors.orangeAccent, 'volleyball.png'),
          Category('Travel', Colors.lightBlue, 'world_travel.png'),
          Category('Family', Colors.yellow, 'family.png'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title, required this.categories}) : super(key: key);

  final String title;
  final List<Category> categories;

  @override
  _HomePageState createState() => _HomePageState(categories);
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  final List<Category> _categories;

  _HomePageState(this._categories);

  void _showToast() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('No magic happened yet')));
  }

  void _addCategory() {
    setState(() => _categories.add(_categories[_categories.length - 3]));
  }

  void _selectTab(int tab) {
    setState(() => _currentTab = tab);
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.red,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          backgroundColor: Colors.red,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.three_k_sharp),
          label: 'Daily',
          backgroundColor: Colors.pinkAccent,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.timeline_outlined),
          label: 'Timeline',
          backgroundColor: Colors.purple,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
          backgroundColor: Colors.deepPurple,
        ),
      ],
      onTap: _selectTab,
      currentIndex: _currentTab,
    );
  }

  Widget _topButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.white),
          onPressed: _showToast,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.attractions,
                color: Colors.red,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: const Text(
                  'Questionnaire Bot',
                  style: TextStyle(fontSize: 16.0, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      backgroundColor: Colors.redAccent,
      onPressed: _addCategory,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: [
          IconButton(
            onPressed: _showToast,
            icon: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      drawer: const Drawer(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: Center(
        child: Column(
          children: [
            _topButton(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio: 2.0,
                children: _categories.map((category) => CategoryItem(category: category)).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _fab(),
    );
  }
}
