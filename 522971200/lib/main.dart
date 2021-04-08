import 'package:flutter/material.dart';

Color colorMain = Colors.deepPurple[200];
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MainPageWidget(),
    );
  }
}

class MainPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorMain,
        title: Center(
          child: const Text('Home'),
        ),
      ),
      body: WidgetList(),
      floatingActionButton: WidgetFloatingActionBar(),
      bottomNavigationBar: WidgetBottomBar(),
    );
  }
}

class WidgetBottomBar extends StatefulWidget {
  @override
  _WidgetBottomBarState createState() => _WidgetBottomBarState();
}

class _WidgetBottomBarState extends State<WidgetBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.date_range_outlined,
          ),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.timeline,
          ),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
          ),
          label: 'Explore',
        ),
      ],
      selectedItemColor: colorMain, 
      unselectedItemColor: Colors.blueGrey,
      onTap: null,
    );
  }
}

class WidgetFloatingActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: null,
      backgroundColor: colorMain,
      child: Icon(Icons.plus_one),
    );
  }
}

class WidgetList extends StatelessWidget {
  final List<String> tasksList = <String>['A', 'B', 'C'];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: tasksList.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(tasksList[index]),
              ),
              Divider(
                color: Colors.black87,
              ),
            ],
          );
        },
      ),
    );
  }
}
