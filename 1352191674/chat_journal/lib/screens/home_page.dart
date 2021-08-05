import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/page_mode.dart';
import '../services/switch_themes.dart';
import 'create_page.dart';
import 'events_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool themeChanged = false;
  final List<Widget> drawerChild = [
    DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
      ),
      child: Text(DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()),
    ),
    ListTile(
      leading: const Icon(Icons.card_giftcard),
      title: Text('Help spread the world'),
      onTap: () {},
    ),
    ListTile(
      leading: const Icon(Icons.search),
      title: Text('Search'),
      onTap: () {},
    ),
    ListTile(
      leading: const Icon(Icons.notifications),
      title: Text('Notifications'),
      onTap: () {},
    ),
    ListTile(
      leading: const Icon(Icons.multiline_chart),
      title: Text('Statistics'),
      onTap: () {},
    ),
    ListTile(
      leading: const Icon(Icons.settings),
      title: Text('Settings'),
      onTap: () {},
    ),
    ListTile(
      leading: const Icon(Icons.feedback),
      title: Text('Feedback'),
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.opacity,
            ),
            onPressed: () {
              if (!themeChanged) {
                themeChanger.setTheme(ThemeMode.dark);
                themeChanged = true;
              } else {
                themeChanger.setTheme(ThemeMode.light);
                themeChanged = false;
              }
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 10,
      ),
      backgroundColor: Colors.grey[92],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerChild,
        ),
      ),
      body: HomePagesList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            List<Object> newPageInfo = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreatePage()));
            var iconIndex = newPageInfo[1] as int;
            var newPageName = newPageInfo[0].toString();

            _HomePagesListState._pages
                .add(AppPage(newPageName, iconsList[iconIndex]));
            (context as Element).markNeedsBuild();
          },
          child: const Icon(Icons.add)),
    );
  }
}

class HomePagesList extends StatefulWidget {
  const HomePagesList({Key? key}) : super(key: key);

  @override
  _HomePagesListState createState() => _HomePagesListState();
}

class _HomePagesListState extends State<HomePagesList> {
  static final _pages = [
    AppPage('Journal', Icons.book),
    AppPage('Notes', Icons.import_contacts_outlined),
    AppPage('Gratitude', Icons.nature_people_outlined)
  ];

  void _showPopupMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info, color: Colors.teal),
              title: Text('Info'),
              onTap: () async {
                _showInfo(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_file_outlined, color: Colors.green),
              title: Text('Pin/Unpin Page'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Page'),
              onTap: () async {
                List<Object> editPageInfo = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePage(
                            isEdit: true,
                            pageTitle: _pages[index].name,
                            pageIcon: _pages[index].icon)));
                var iconIndex = editPageInfo[1] as int;
                var editPageName = editPageInfo[0].toString();
                setState(() {
                  _pages[index] = AppPage(editPageName, iconsList[iconIndex]);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text('Delete Page'),
              onTap: () {
                setState(() {
                  _pages.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showInfo(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return InfoPage(title: _pages[index].name, icon: _pages[index].icon);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      separatorBuilder: (context, index) => Divider(),
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        return ListTile(
          onLongPress: () => _showPopupMenu(index),
          contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MyListEventsPage(title: _pages[index].name),
            ),
          ),
          leading: Icon(_pages[index].icon),
          title: Text(
            _pages[index].name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key, required this.title, required this.icon})
      : super(key: key);
  final String title;
  final IconData icon;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
