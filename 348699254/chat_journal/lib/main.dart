import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: _createAppBarTitle(),
          leading: _buildAppBarLeftButton(),
          actions: <Widget> [
           _buildAppBarRightButton(),
          ],
        ),
        body: _bodyStructure(),
        floatingActionButton: _createFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}

Widget _createAppBarTitle(){
  return const Align(
    child: Text('Home'),
    alignment: Alignment.center,
  );
}

Widget _buildAppBarLeftButton(){
  return IconButton(
      icon: const Icon(Icons.menu_outlined),
      onPressed: () {
        print('Click on menu outlined button');
      }
  );
}

Widget _buildAppBarRightButton(){
  return IconButton(
    icon: const Icon(Icons.wb_incandescent_outlined),
    onPressed: () => {
      print('Click on incandescent outlined button')
    },
  );
}

Widget _buildContainer() {
  return Center(
    child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.fromLTRB(40, 6, 40, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          const Icon(
            Icons.android_sharp
          ),
          const Text('Questionnaire Bot'),
        ],),
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(15)
        ),
    ),
  );
}

Widget _bodyStructure(){
  return Column(
    children: <Widget>[
      Row(
          children: <Widget>[
            Expanded(
              child: _buildContainer(),
            ),
          ]
      ),
      Expanded(
        child:
        _buildList(),
      )
    ],
  );
}

Widget _buildList() {
  return ListView(
    children: [
      const Divider(),
      _tile('Travel', 'No events. Click to create one', Icons.airplane_ticket),
      const Divider(),
      _tile('Family', 'No events. Click to create one', Icons.weekend),
      const Divider(),
      _tile('Sports', 'No events. Click to create one', Icons.sports_baseball_sharp),
      const Divider(),
    ],
  );
}

ListTile _tile(String title, String subtitle, IconData icon) {
  return ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 30,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    ),
  );
}

Widget _createFloatingActionButton(){
  return FloatingActionButton(
    onPressed: () {
      // Add your onPressed code here!
    },
    child: const Icon(
        Icons.add,
        color: Colors.brown),
    backgroundColor: Colors.amberAccent,
  );
}


Widget _buildBottomNavigationBar(){
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    //currentIndex: this.selectedIndex,
    items: [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: ('Home'),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        label: ('Daily'),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.exposure),
        label: ('Timeline'),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.api),
        label: ('Explore'),
      )
    ],
    onTap: (index) {
      //this.onTapHandler(index);
    },
  );
}