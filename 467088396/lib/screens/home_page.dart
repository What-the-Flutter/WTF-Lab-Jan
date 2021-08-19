import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../custom_themes.dart';
import '../models/category.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_chat_button.dart';
import 'create_page.dart';
import 'event_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool themeChanged = false;
  int _selectedCategory = -1;
  final List<Category> _categories = <Category>[
    Category(
      name: 'Travel',
      iconData: Icons.flight_takeoff_rounded,
      createdTime: DateTime.now(),
    ),
    Category(
      name: 'Family',
      iconData: Icons.family_restroom_rounded,
      createdTime: DateTime.now(),
    ),
    Category(
      name: 'Sport',
      iconData: Icons.sports_tennis_rounded,
      createdTime: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: _body(),
        floatingActionButton: _floatingActionButton(context),
        bottomNavigationBar: const BottomNavBar());
  }

  Column _body() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        BotButton(size: size),
        _categoryList(),
      ],
    );
  }

  Expanded _categoryList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) => _categoryCard(
          index,
          _categories[index],
        ),
      ),
    );
  }

  GestureDetector _categoryCard(int index, Category category) {
    return GestureDetector(
      onLongPress: () {
        _selectedCategory = index;
        _showOptions(context);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventPage(title: category.name)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(3, 5),
              color: primaryColor.withOpacity(0.10),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            category.name,
            style: TextStyle(
                color: Theme.of(context).textTheme.caption!.color,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 1),
          ),
          subtitle: const Text('No events. Click to create one.'),
          leading: Icon(
            category.iconData,
            color: const Color(0xff87D2F7),
            size: 32,
          ),
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _createPage(context),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withOpacity(0.20),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          size: 32,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _createPage(BuildContext context) async {
    final category = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreatePage()));
    if (category is Category && mounted) {
      setState(() => _categories.add(category));
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/menu.svg'),
        onPressed: () {},
      ),
      title: const Text(
        'Diary',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          letterSpacing: 6,
          fontSize: 26,
        ),
      ),
      actions: [
        _changeThemeIconButton(context),
      ],
    );
  }

  IconButton _changeThemeIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        themeChanged = !themeChanged;
        CustomTheme.instanceOf(context).changeTheme();
      },
      //iconSize: 28,
      icon: const Icon(Icons.nightlight),
      color: Colors.white,
    );
  }

  Future<dynamic> _showOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.info, color: secondColor),
              title: const Text('Info'),
              onTap: () {
                Navigator.of(context).pop();
                _showInfo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: secondColor),
              title: const Text('Edit'),
              onTap: _editPage,
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: secondColor),
              title: const Text('Delete'),
              onTap: () {
                setState(() => _categories.removeAt(_selectedCategory));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _showInfo() {
    var category = _categories[_selectedCategory];
    var date = category.createdTime;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(category.iconData),
                title: Text(category.name),
              ),
              const Text('Created'),
              Text('${date.day}.${date.month}.${date.year} at '
                  '${date.hour}:${date.minute}'),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editPage() async {
    final category = await Navigator.of(context).popAndPushNamed(
      '/create-page',
      arguments: _categories[_selectedCategory],
    );
    if (category is Category) {
      setState(() {
        _categories[_selectedCategory] = category;
      });
    }
  }
}
