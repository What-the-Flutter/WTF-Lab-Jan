import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../chat_list_tile.dart';
import '../domain.dart';
import '../theme_changer.dart';
import 'add_chat_tile_page.dart';
import 'chat_page.dart';
import 'update_chat_tile_page.dart';

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
          onTap: () => _openChat(context, widget.categories[index - 1]),
          onLongPress: () =>
              _selectAction(context, widget.categories[index - 1]),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  void _openUpdatePage(BuildContext context, Category category,
      BuildContext dialogContext) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateCategoryPage(category: category)));
    Navigator.pop(dialogContext);
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
        builder: (dialogContext) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: Container(
              height: 240.0,
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
                      Navigator.pop(dialogContext);
                    },
                  ),
                  ListTile(
                    title: Text('Update'),
                    leading: CircleAvatar(
                        foregroundColor: Colors.black54,
                        child: Icon(Icons.lightbulb)),
                    onTap: () async {
                      _openUpdatePage(context, category, dialogContext);
                    },
                  ),
                  ListTile(
                      title: Text('Info'),
                      leading: CircleAvatar(
                          foregroundColor: Colors.black54,
                          child: Icon(Icons.info)),
                      onTap: () {
                        Navigator.pop(dialogContext);
                        showDialog(
                            context: context,
                            builder: (infoDialogContext) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  elevation: 16,
                                  child: Container(
                                    height: 300.0,
                                    width: 220.0,
                                    child: ListView(children: <Widget>[
                                      SizedBox(height: 20),
                                      ListTile(
                                        leading: CircleAvatar(
                                            foregroundColor: Colors.black54,
                                            child: Icon(category.iconData)),
                                        title: Text(category.name),
                                      ),
                                      SizedBox(height: 20),
                                      ListTile(
                                        title: Text('Created'),
                                        subtitle: Text(
                                            DateFormat('yyyy-MM-dd KK:mm:ss')
                                                .format(category.dateTime)),
                                      ),
                                      SizedBox(height: 10),
                                      ListTile(
                                        title: Text('Last Event'),
                                        subtitle: category.events.isEmpty
                                            ? Text('No events')
                                            : Text(
                                                DateFormat('yyyy-MM-dd KK:mm:ss')
                                                    .format(category.events
                                                        .first.dateTime)),
                                      ),
                                      SizedBox(height: 20),
                                      Center(
                                        child: Container(
                                          height: 40.0,
                                          width: 50.0,
                                          child: ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(infoDialogContext),
                                              child: Text('Ok')),
                                        ),
                                      ),
                                    ]),
                                  ));
                            });
                      })
                ],
              ),
            ),
          );
        });
    setState(() {});
  }
}
