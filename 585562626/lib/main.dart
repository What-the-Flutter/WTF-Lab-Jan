import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category_notes.dart';
import 'constants.dart';
import 'models/category.dart';
import 'models/note.dart';
import 'widgets/category_item.dart';

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
          NoteCategory('Sports', Colors.orangeAccent, 'sports.png'),
          NoteCategory('Travel', Colors.lightBlue, 'travel.png'),
          NoteCategory('Family', Colors.indigoAccent, 'family.png'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title, required this.categories}) : super(key: key);

  final String title;
  final List<NoteCategory> categories;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  late final List<NoteCategory> _categories = widget.categories;
  late final Map<int, List<BaseNote>> _categoryNotes = {
    for (var category in _categories) category.id: []
  };

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

  Widget _topButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(Insets.xmedium),
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
                padding: const EdgeInsets.symmetric(vertical: Insets.xmedium),
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

  Widget _categoriesGrid() {
    return Expanded(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: Insets.xsmall,
        crossAxisSpacing: Insets.xsmall,
        padding: const EdgeInsets.fromLTRB(
          Insets.large,
          0.0,
          Insets.large,
          Insets.medium,
        ),
        childAspectRatio: 1.0,
        children: _categories
            .map(
              (category) => CategoryItem(
                category: category,
                onTap: _onCategoryClick,
              ),
            )
            .toList(),
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
          icon: Icon(Icons.list_alt_outlined),
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
          children: [_topButton(), _categoriesGrid()],
        ),
      ),
      floatingActionButton: _fab(),
    );
  }

  void _onCategoryClick(NoteCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryNotes(category: category, notes: _categoryNotes[category.id] ?? []),
      ),
    );
  }
}
