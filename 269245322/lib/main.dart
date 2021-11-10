import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: const IconButton(
          icon: Icon(Icons.menu),
          onPressed: null,
        ),
        actions: const <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: <ListObject>[
          ListObject(
            heading: 'node 1',
            data: 'some datasome datasome datasome',
            avatarUrl: '1.png',
            ptiority: 'high',
          ),
          ListObject(
            heading: 'node 1',
            data: 'some data',
            avatarUrl: '1.png',
            ptiority: 'medium',
          ),
          ListObject(
            heading: 'node 1',
            data: 'some data',
            avatarUrl: '1.png',
            ptiority: 'low',
          ),
          ListObject(
            heading: 'node 1',
            data: 'some data',
            avatarUrl: '1.png',
            ptiority: 'high',
          ),
          ListObject(
            heading: 'node 1',
            data: 'some data',
            avatarUrl: '1.png',
            ptiority: 'high',
          ),
          ListObject(
            heading: 'node 1',
            data: 'some data',
            avatarUrl: '1.png',
            ptiority: 'medium',
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Timeline',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: null,
      ),
    );
  }
}

class ListObject extends StatelessWidget {
  final String heading;
  final String data;
  final String avatarUrl;
  final String ptiority;

  final Map<String, Color> nodePropertyColor = {
    'high': Colors.black,
    'medium': Colors.white,
    'low': Colors.yellow,
  };

  ListObject(
      {required this.heading,
      required this.data,
      required this.avatarUrl,
      required this.ptiority});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CircleAvatar(
                radius: 6.0,
                backgroundColor: nodePropertyColor[ptiority],
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                data,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
