import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _darkTheme = false;
  int _currentScreen = 0;
  final _entries = <String>[
    'Travel',
    'Work',
    'Family',
    'Sport',
  ];
  final _icons = <IconData>[
    Icons.flight_takeoff,
    Icons.business_center,
    Icons.weekend,
    Icons.directions_run,
  ];

  /// Stub method
  ///
  /// Substitute for yet-to-be-developed methods
  /// Will be removed during development
  void _mockup(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _changeTheme() {
    setState(() {
      _darkTheme = !_darkTheme;
    });
  }

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _currentScreen = index;
      _mockup((index + 1).toString());
    });
  }

  void _onListItemTapped(String category) {
    _mockup('List Item "$category" pressed');
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(widget.title),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(_darkTheme ? Icons.brightness_3 : Icons.brightness_5),
            tooltip: _darkTheme ? 'Dark Theme' : 'Light Theme',
            onPressed: () {
              _changeTheme();
              _mockup('Theme is changed (DarkTheme = $_darkTheme)');
            },
          ),
        )
      ],
    );
  }

  Widget _drawer() {
    return const Drawer(
        child: Center(
      child: Text(
        'Empty Drawer',
        style: TextStyle(fontSize: 48),
      ),
    ));
  }

  Widget _body() {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        return Container(
            height: 60,
            child: InkWell(
              child: Row(
                children: [
                  Icon(_icons[index]),
                  const SizedBox(width: 20),
                  Text(_entries[index]),
                ],
              ),
              onTap: () => _onListItemTapped(_entries[index]),
            ));
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  BottomNavigationBar _bottomBar(){
    return BottomNavigationBar(
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
      onTap: _onBottomBarItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      body: _body(),
      bottomNavigationBar: _bottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mockup('Floating Button pressed');
        },
        tooltip: 'Add entry',
        child: const Icon(Icons.add),
      ),
    );
  }
}
