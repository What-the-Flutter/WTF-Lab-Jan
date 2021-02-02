import 'package:flutter/material.dart';

import 'page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<JournalPage> pages = <JournalPage>[
    JournalPage("Notes", Icons.notes)..addEvent(Event("My new note")),
    JournalPage("Food", Icons.fastfood),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: _buildDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {},
              child: Center(
                child: Text("Questionnaire bot"),
              ),
            ),
          ),
          _buildListView(), //ListView
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: "New page",
      child: Icon(Icons.add),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.yellow,
            ),
            child: null,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Item'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(2),
      itemCount: pages.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 30,
                child: Icon(
                  pages[index].icon,
                  color: Colors.yellow,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pages[index].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    pages[index].eventCount > 0
                        ? pages[index].lastEvent.description
                        : "No events yet.",
                  )
                ],
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Timeline',
        ),
      ],
      currentIndex: 0,
      backgroundColor: Colors.yellow,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black45,
    );
  }
}
