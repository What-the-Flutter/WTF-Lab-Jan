import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_app/event_page.dart';

import 'list_view_suggestions.dart';

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
        'Family', 'No Events. Click to create one.', 'assets/images/baby.png'),
    ListViewSuggestions(
        'Food', 'No Events. Click to create one.', 'assets/images/burger.png'),
    ListViewSuggestions(
        'Sport', 'No Events. Click to create one.', 'assets/images/gym.png'),
    ListViewSuggestions('Travel', 'No Events. Click to create one.',
        'assets/images/airplane.png'),
    ListViewSuggestions('Entertainment', 'No Events. Click to create one.',
        'assets/images/game_controller.png'),
    ListViewSuggestions('Study', 'No Events. Click to create one.',
        'assets/images/university.png'),
    ListViewSuggestions('Work', 'No Events. Click to create one.',
        'assets/images/work.png'),
    ListViewSuggestions('Supermarket', 'No Events. Click to create one.',
        'assets/images/supermarket.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBarHomePage(widget.title),
      drawer: _buildDrawer(),
      body: _buildHomePageBody(list),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndexBotNavBar,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: _buildBotNavBarItem(),
        onTap: (index) {
          setState(() {
            //here will implements logic
            _currentIndexBotNavBar = index;
          });
        },
      ),
      floatingActionButton: _buildFloatActButHomePage(),
    );
  }

  ///Builds floatingActionButton to add a new event category.
  Widget _buildFloatActButHomePage() {
    return FloatingActionButton(
      tooltip: 'New',
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      hoverColor: Colors.orange,
      onPressed: () {},
    );
  }

  ///Builds AppBar for [HomePage].
  Widget _buildAppBarHomePage(String title) {
    return AppBar(
      title: Container(
        child: Text(title),
        alignment: Alignment.center,
      ),
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.invert_colors,
            color: Colors.white,
          ),
          onPressed: () {},
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
                colors: [Colors.deepOrangeAccent, Colors.red],
              ),
            ),
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
            leading: Icon(Icons.tag),
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

  Widget _buildHomePageBody(List list) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _buildQuestionBotRaisedButton(),
        ),
        Expanded(
          flex: 8,
          child: _buildListViewSuggestions(),
        ),
      ],
    );
  }

  Widget _buildListViewSuggestions() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildRow(list, index);
          },
        ),
      ),
    );
  }

  Widget _buildQuestionBotRaisedButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 7.0,
      ),
      child: RaisedButton.icon(
        label: Text(
          'Questionnaire Bot',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        textColor: Colors.black,
        splashColor: Colors.redAccent,
        icon: Icon(Icons.question_answer),
        color: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  ///Builds suggestion card.
  Widget _buildRow(List<ListViewSuggestions> list, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      color: Colors.redAccent,
      child: ListTile(
        leading: Image.asset(list[index].imagePathOfSuggestion),
        title: Text(
          list[index].nameOfSuggestion,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(list[index].infoOfSuggestion),
        hoverColor: Colors.orangeAccent,
        tileColor: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onTap: () {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventPage(
                      title: list[index].nameOfSuggestion,
                    )));
            // print('tap ${list[index].nameOfSuggestion}');
          });
        },
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
}
