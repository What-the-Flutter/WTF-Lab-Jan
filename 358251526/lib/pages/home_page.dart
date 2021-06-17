import 'package:flutter/material.dart';
import 'package:my_journal/chat_list_tile.dart';
import 'package:my_journal/main.dart';
import 'package:my_journal/domain.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: BodyData(),
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
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        //backgroundColor: Colors.tealAccent,
        //foregroundColor: Colors.black54,
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myBottomNavigationBar(context);
  }
}

Widget _myBottomNavigationBar(BuildContext context) {
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

class BodyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

class CategoriesList extends StatefulWidget {
  final List<Category> categories;

  const CategoriesList({Key? key, required this.categories}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  String subtitle = 'No events. Click to create one.';

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: categories.length + 1,
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
          title: categories[index - 1].name,
          icon: Icon(categories[index - 1].iconData),
          subtitle: subtitle,
          onTap: () => openChat(context, categories[index - 1]),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  void changeSubtitle(String newSubtitle) {
    setState(() {
      subtitle = newSubtitle;
    });
  }
}

void openChat(BuildContext context, Category category) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Chat(category: category)));
}

Widget _myListView(BuildContext context) {
  return CategoriesList(categories: categories);
}
