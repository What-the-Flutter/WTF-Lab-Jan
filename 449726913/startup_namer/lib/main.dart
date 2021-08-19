import 'package:flutter/material.dart';
import 'events.dart';

void main() => runApp(MyApp());

int _selectedIndex = 0;

List<String> message = <String>['First node', 'Second node', 'Third node '];


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
        title: const Center(
          child: Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: EventsList(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
class EventsList extends StatelessWidget {
  final events = <String>['Travel', 'Family', 'Sport'];
  final icons = [Icons.airplanemode_active, Icons.weekend, Icons.sports_basketball];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            _navigateToNextScreen(context);
          },
          leading: Icon(icons[index]),
          title: Text(events[index], style: const TextStyle(fontSize: 22, color: Colors.black)),
          // ignore: avoid_unnecessary_containers
          subtitle: Container(
            child: const Text(
              'No events. Click to create one',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EventScreen()));
  }
}
