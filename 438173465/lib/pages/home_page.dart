import 'package:flutter/material.dart';
import 'package:flutter_wtf/models/event.dart';

import '../db/db_helper.dart';
import '../models/event_type.dart';
import '../theme_changer.dart';
import 'event_screen.dart';
import 'events_type_add.dart';

final Map<String, IconData> map = {
  'Travel': Icons.flight_takeoff,
  'Family': Icons.house,
  'Sports': Icons.fitness_center,
};

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  DBProvider db;

  @override
  void initState() {
    print('init');

    super.initState();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeTheme() {
    ThemeBuilder.of(context).changeTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.opacity),
            onPressed: _changeTheme,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40, top: 10, bottom: 10, right: 40),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ThemeBuilder.of(context).getCurrentTheme() ==
                        Brightness.dark
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.orangeAccent[100],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.android, color: Colors.black),
                  SizedBox(width: 20),
                  Text(
                    'Questionnaire Bot',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder<List<EventType>>(
                future: DBProvider.db.fetchEventTypeList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: snapshot.data.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        var item = snapshot.data[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 40,
                            child: Icon(
                              map.values.elementAt(1),
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              EventScreen.routeName,
                              arguments: item,
                            );
                          },
                          title: Text(item.title),
                          subtitle: Text(item.icon),
                          hoverColor: Colors.redAccent,
                        );
                      },
                    );
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No events'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventTypeAdd()),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        items: [
          _bottomNavBarItem(label: 'Home', icon: Icons.class_),
          _bottomNavBarItem(label: 'Daily', icon: Icons.assignment),
          _bottomNavBarItem(label: 'Timeline', icon: Icons.map),
          _bottomNavBarItem(label: 'Explore', icon: Icons.explore),
        ],
      ),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(
      {IconData icon, String label, Function function}) {
    return BottomNavigationBarItem(
      label: label,
      icon: Icon(icon),
    );
  }
}
