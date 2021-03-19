import 'package:flutter/material.dart';
import 'package:flutter_wtf/theme_changer.dart';

final Map<String, IconData> map = {
  'Travel': Icons.flight_takeoff,
  'Family': Icons.house,
  'Sports': Icons.fitness_center,
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultBrightness: Brightness.dark,
      builder: (context, _brightness) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            brightness: _brightness,
          ),
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

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
                      : Colors.orangeAccent[100]),
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
              child: ListView.separated(
            itemCount: map.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  child: Icon(
                    map.values.elementAt(index),
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.grey,
                ),
                title: Text(map.keys.elementAt(index)),
                subtitle: Text('No Events. Click to create one.'),
                hoverColor: Colors.redAccent,
              );
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {},
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
            _bottomNavBarItem(label: 'Timeline', icon: Icons.explore),
          ]),
    );
  }

  _bottomNavBarItem({IconData icon, String label, Function function}) {
    return BottomNavigationBarItem(label: label, icon: Icon(icon));
  }
}
