import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bottom navigation.
      bottomNavigationBar: HomePageNavigationBar(),
      // Main home page button.
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(30, 144, 255, 100),
        onPressed: () {
          // Update state
        },
      ),
      drawer: HomePageDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Home",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                // Update state
              },
              child: Icon(Icons.invert_colors),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: IconWrapper(Icons.airplanemode_active),
            onTap: () {},
            title: Text(
              "Travel",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              "No Events. Click to create one.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          ListTile(
            leading: IconWrapper(Icons.family_restroom),
            onTap: () {},
            title: Text(
              "Family",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              "No Events. Click to create one.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          ListTile(
            leading: IconWrapper(Icons.fitness_center_rounded),
            onTap: () {},
            title: Text(
              "Sports",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              "No Events. Click to create one.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          ListTile(
            leading: IconWrapper(Icons.fastfood),
            onTap: () {},
            title: Text(
              "Food",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              "No Events. Click to create one.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom navigation bar on home page.
class HomePageNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_rounded),
          label: "Daily",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: "Timeline",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: "Explore",
        ),
      ],
      selectedItemColor: Colors.deepPurple,
      selectedFontSize: 15,
      unselectedItemColor: Colors.grey,
      unselectedFontSize: 15,
      showUnselectedLabels: true,
    );
  }
}

// Drawer for application menu.
class HomePageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Sized box to change the drawer header height.
          SizedBox(
            height: 120,
            child: DrawerHeader(
              child: ListTile(
                title: Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
          ),
          ListTile(
            title: Text(
              "Item 1",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            onTap: (){
              // Need to add realization!
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "Item 2",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            onTap: (){
              // Need to add realization!
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class IconWrapper extends StatelessWidget {
  IconData _icon;

  IconWrapper(IconData icon) {
    this._icon = icon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Ink(
        decoration: ShapeDecoration(
          color: Colors.deepPurpleAccent,
          shape: CircleBorder(),
        ),
        child: Icon(
          _icon,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}