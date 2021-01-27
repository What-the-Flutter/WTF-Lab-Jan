
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ListViewSuggestions.dart';

///Home page class.
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

///This class implements the main logic of the [HomePage].
class _HomePageState extends State<HomePage> {
  int _currentIndexBotNavBar = 0;

  //Temporary list to test functionality.
  List<ListViewSuggestions> list = [
    ListViewSuggestions(
        'Family', 'No Events. Click to create one.', 'resources/baby.png'),
    ListViewSuggestions(
        'Food', 'No Events. Click to create one.', 'resources/burger.png'),
    ListViewSuggestions(
        'Sport', 'No Events. Click to create one.', 'resources/gym.png'),
    ListViewSuggestions(
        'Travel', 'No Events. Click to create one.', 'resources/airplane.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarHomePage(widget.title),
      drawer: _buildDrawer(),
      body: _buildSuggestionsHomePage(list),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndexBotNavBar,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.redAccent,
        items: _buildBotNavBarItem(),
        onTap: (index) {
          setState(() {
            //here will implements logic
            _currentIndexBotNavBar = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.redAccent,
        hoverColor: Colors.red,
        onPressed: (){},
      ),
    );
  }
}

///Builds AppBar for [HomePage].
Widget _buildAppBarHomePage(String title) {
  return AppBar(
    title: Container(
      child: Text(title),
      alignment: Alignment.center,
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.invert_colors,
            color: Colors.white),
        onPressed: null,
      )
    ],
  );
}

///Builds Drawer.
Widget _buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: const <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.redAccent, Colors.blue])),
          accountName: Text(
            'Alex',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text("shevelyanchik01@mail.ru"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('All Pages'),
        ),
        ListTile(
          leading: Icon(Icons.timeline),
          title: Text('Timeline'),
        ),
        ListTile(
          leading: Icon(CupertinoIcons.smiley),
          title: Text('Daily'),
        ),
        ListTile(
          leading: Icon(CupertinoIcons.bookmark),
          title: Text('Tags'),
        ),
        ListTile(
          leading: Icon(Icons.assessment_outlined),
          title: Text('Statistics'),
        ),
        ListTile(
          leading: Icon(Icons.search),
          title: Text('Search'),
        ),
        Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notifications'),
        ),
        ListTile(
          leading: Icon(Icons.invert_colors),
          title: Text('Change Theme'),
        ),
      ],
    ),
  );
}

///Builds ListView with suggestions for events.
Widget _buildSuggestionsHomePage(List list) {
  return ListView.builder(
    padding: EdgeInsets.all(10.0),
    itemCount: list.length,
    itemBuilder: (context, index) {
      return _buildRow(list, index);
    },
  );
}

///Builds suggestion card.
Widget _buildRow(List<ListViewSuggestions> list, int index) {
  return Card(
    color: Colors.white54,
    child: ListTile(
      hoverColor: Colors.redAccent,
      tileColor: Colors.white60,
      leading: Image.asset(list[index].imagePathOfSuggestion),
      title: Text(
        list[index].nameOfSuggestion,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(list[index].infoOfSuggestion),
      onTap: (){},
    ),
  );
}

///Builds [BottomNavigationBarItem] elements.
List<BottomNavigationBarItem> _buildBotNavBarItem() {
  return const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home_sharp),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment_outlined),
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
  ];
}
