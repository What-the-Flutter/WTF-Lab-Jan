import 'package:flutter/material.dart';

import 'chat_list_tile.dart';
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
                color: Colors.teal,
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
      //ListView
      appBar: AppBar(
        title: Center(
          child: Text('Home'),
        ),
        actions: [
          IconButton(icon: Icon(Icons.invert_colors), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black54,
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
    unselectedItemColor: Colors.blueGrey,
    selectedItemColor: Colors.teal,
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
              ? 'No events. Click to create one.'
              : categories[index - 1].events.last.text,
          onTap: () => openChat(context, widget.categories[index - 1]),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

void openChat(BuildContext context, Category category) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Chat(category: category)));
}

Widget _myListView(BuildContext context) {
  return CategoriesList(categories: categories);
}

class Event {
  String text;
  DateTime dateTime;

  Event(this.text, this.dateTime);
}

class Category {
  String name;
  List<Event> events;
  IconData iconData;

  Category(this.name, this.events, this.iconData);
}

List<Category> categories = [
  Category('Family', [], Icons.family_restroom),
  Category('Job', [], Icons.work),
  Category('Travel', [], Icons.local_shipping),
  Category('Sports', [], Icons.sports_basketball),
  Category('Friends', [], Icons.wine_bar),
];
