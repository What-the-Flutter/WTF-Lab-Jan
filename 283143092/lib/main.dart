import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _darkTheme = false;
  int _currentScreen = 0;

  /// Stub method
  ///
  /// Substitute for yet-to-be-developed methods
  /// Will be removed during development
  void _mockup(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Changes app theme state
  void _switchTheme() {
    setState(() {
      _darkTheme = !_darkTheme;
    });
  }

  /// Changes current screen state to [index]
  void _onBottomBarItemTapped(int index) {
    setState(() {
      _currentScreen = index;
    });
    _mockup((index+1).toString());
  }

  /// Shows details to give [category]
  void _onListItemTapped(String category){
    _mockup('List Item "$category" pressed');
  }

  @override
  Widget build(BuildContext context) {
    final entries = <String>['Travel', 'Work', 'Family', 'Sport'];
    final icons = <IconData>[Icons.flight_takeoff, Icons.business_center,
      Icons.weekend, Icons.directions_run];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(
              icon: Icon(_darkTheme ? Icons.brightness_3 : Icons.brightness_5),
              tooltip: _darkTheme ? 'Dark Theme' : 'Light Theme',
              onPressed: () {
                _switchTheme();
                _mockup('Theme is changed (DarkTheme = $_darkTheme)');
              },
            ),
          )
        ],
      ),
      drawer: const Drawer(
        child: Center (
          child: Text (
              'Empty Drawer',
              style: TextStyle(fontSize: 48),
          ),
        )
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(10),
              //color: Colors.black12,
              height: 50,
              // color: Colors.black12,
              child: Row(
                children: [
                  Icon(icons[index]),
                  const SizedBox(width: 20),
                  Text(entries[index]),
                ],
              ),
            ),
            onTap: () {_onListItemTapped(entries[index]);},
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_mockup('Floating Button pressed');},
        tooltip: 'Add entry',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chrome_reader_mode),
            label: 'Timeline',
          ),
        ],
        currentIndex: _currentScreen,
        selectedItemColor: Colors.amber[800],
        onTap: _onBottomBarItemTapped,
      ),
    );
  }
}
