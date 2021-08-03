import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomePage(),
      theme:
          ThemeData(primaryColor: Color.lerp(Colors.green, Colors.blue, 0.4)),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Home'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            tooltip: 'Change Theme',
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(),
      body: EventsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add New Event name',
        backgroundColor: Colors.yellow,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_added),
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
      ),
    );
  }
}

class EventsList extends StatelessWidget {
  static const events = <String>[
    'Event 1 name',
    'Event 2 name',
    'Event 3 name',
  ];

  const EventsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: events.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.star),
            title: Text(events[index], style: TextStyle(fontSize: 22)),
            subtitle: Container(
              child: Text('Event ${index + 1} description'),
            ),
          );
        });
  }
}
