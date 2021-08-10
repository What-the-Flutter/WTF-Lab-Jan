import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _selectedScreenContent = <Widget>[
    _EventsList(),
    Center(
      child: Text(
        'Daily Screen Content',
        style: TextStyle(fontSize: 25),
      ),
    ),
    Center(
      child: Text(
        'Timeline Screen Content',
        style: TextStyle(fontSize: 25),
      ),
    ),
    Center(
      child: Text(
        'Explore Screen Content',
        style: TextStyle(fontSize: 25),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const Drawer(),
      body: _selectedScreenContent.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.yellow[600],
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
        onTap: ((index) {
          setState(() {
            _selectedIndex = index;
          });
        }),
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  static const _events = <String>[
    'Event 1 name',
    'Event 2 name',
    'Event 3 name',
  ];

  const _EventsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _events.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.star),
          title: Text(_events[index], style: const TextStyle(fontSize: 25)),
          subtitle: Text('Event ${index + 1} description'),
        );
      },
    );
  }
}
