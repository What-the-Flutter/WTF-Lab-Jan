import 'package:flutter/material.dart';
import 'package:my_journal/chat_list_tile.dart';
import 'package:my_journal/domain.dart';
import 'package:my_journal/pages/update_chat_tile_page.dart';
import 'package:my_journal/theme_changer.dart';

import 'add_chat_tile_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categoriesList = initialCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  //color: Colors.teal,
                  ),
              child: Text('Profile'),
            ),
            ListTile(
              title: Text('Add profile'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Exit'),
              onTap: () {},
            )
          ],
          padding: EdgeInsets.zero,
        ),
      ),
      body: CategoriesList(categories: categoriesList),
      appBar: AppBar(
        title: Center(
          child: Text('Home'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: () => ThemeChanger.instanceOf(context).changeTheme(),
          )
        ],
      ),
      bottomNavigationBar: _myBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCategory(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _myBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          backgroundColor: Colors.white60,
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      showUnselectedLabels: true,
    );
  }

  void addCategory(BuildContext context) async {
    final newCategory = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddCategoryPage()));
    if (newCategory is Category) {
      setState(() {
        categoriesList.add(newCategory);
      });
    }
  }
}

class CategoriesList extends StatefulWidget {
  final List categories;

  const CategoriesList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  String subtitle = 'No events. Click to create one.';

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.categories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Center(
            child: Container(
              width: 350.0,
              height: 60.0,
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.android),
                label: Text('Questionnaire Bot'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
              ),
            ),
          );
        }
        return ChatListTile(
          title: widget.categories[index - 1].name,
          icon: Icon(widget.categories[index - 1].iconData),
          subtitle: widget.categories[index - 1].events.isEmpty
              ? subtitle
              : widget.categories[index - 1].events.first.text,
          onTap: () => _openUpdatePage(context, widget.categories[index - 1]),
          onLongPress: () =>
              _selectAction(context, widget.categories[index - 1]),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  void _openUpdatePage(BuildContext context, Category category) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UpdateCategoryPage(category: category)));
    setState(() {});
  }

  void _openChat(BuildContext context, Category category) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Chat(category: category)));
    setState(() {});
  }

  void _selectAction(BuildContext context, Category category) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: Container(
              height: 200.0,
              width: 200.0,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Select an action',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text('Delete'),
                    leading: CircleAvatar(
                      foregroundColor: Colors.black54,
                      child: Icon(Icons.clear),
                    ),
                    onTap: () {
                      widget.categories.remove(category);
                    },
                  ),
                  ListTile(
                    title: Text('Update'),
                    leading: CircleAvatar(
                        foregroundColor: Colors.black54,
                        child: Icon(Icons.lightbulb)),
                    onTap: () {
                      _openUpdatePage(context, category);
                    },
                  )
                ],
              ),
            ),
          );
        });
    setState(() {});
  }

}
