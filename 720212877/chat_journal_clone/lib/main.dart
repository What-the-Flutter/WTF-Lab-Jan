import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final Map<String, IconData> map = {
  'Travel': Icons.flight_takeoff,
  'Family': Icons.house,
  'Sports': Icons.fitness_center,
};

class MyApp extends StatelessWidget {
  static const String _title = 'Chat Journal Clone';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Chat Journal'),
        centerTitle: true,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.opacity,  color: Colors.white),
            onPressed: () {},
          )
        ],
          backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40, top: 10, bottom: 10, right: 40),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.amber,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.android_outlined, color: Colors.white),
                  SizedBox(width: 20),
                  Text(
                    'Questionnaire Bot',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey,),
          Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey,),
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
                    title: Text(map.keys.elementAt(index), style: TextStyle(color: Colors.white)),
                    subtitle: Text('No Events. Click to create one.', style: TextStyle(color: Colors.white)),
                  );
                },
              )),
          Divider(color: Colors.grey,),
        ],

      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber,
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed ,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.amber,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}



