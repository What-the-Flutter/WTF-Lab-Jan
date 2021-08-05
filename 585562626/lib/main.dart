import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category.dart';
import 'category_item.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Notes',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.indigoAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.indigoAccent,
            padding: const EdgeInsets.all(Insets.xsmall),
          ),
        ),
        fontFamily: Fonts.ubuntu,
      ),
      home: HomePage(
        title: 'Home',
        categories: [
          Category('Sports', Colors.orangeAccent, 'sports.png'),
          Category('Travel', Colors.lightBlue, 'travel.png'),
          Category('Family', Colors.indigoAccent, 'family.png'),
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
      selectedItemColor: Theme.of(context).accentColor,
      unselectedItemColor: Colors.indigo,
      backgroundColor: Theme.of(context).primaryColor,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.three_k_sharp),
          label: 'Daily',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.timeline_outlined),
          label: 'Timeline',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
      ],
      onTap: _selectTab,
      currentIndex: _currentTab,
    );
  }

  Widget _topButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(Insets.small),
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: ElevatedButton(
          onPressed: _showToast,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: Insets.small),
                child: Icon(
                  Icons.attractions,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: Insets.medium),
                child: const Text(
                  'Questionnaire Bot',
                  style: TextStyle(
                    fontSize: FontSize.normal,
                  ),
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
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
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
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: Insets.xsmall,
                crossAxisSpacing: Insets.xsmall,
                padding: const EdgeInsets.fromLTRB(Insets.large, 0.0, Insets.large, Insets.medium),
                childAspectRatio: 1.0,
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
