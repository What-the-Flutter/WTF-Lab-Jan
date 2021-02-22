import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Quicksand'
    ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _addPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String subtitle = 'No Events';
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text(
              widget.title,
            style: TextStyle( fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        leading: Container(
            child: Icon(Icons.menu)),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 30),
              child: Icon(Icons.adjust_sharp)
          )
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            color: Colors.deepPurple,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)
              ),
              color: Colors.white,
            ),
            //padding: EdgeInsets.only(top: 25),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.orange[50],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10,bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help,
                            size: 35,
                            color: Colors.orange,
                          ),
                          Text(
                          'Questionnaire Bot',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                      ),
                    ),
                  ],
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[50],
                      radius: 30,
                      child: Icon(
                        Icons.book,
                        size: 35,
                        color: Colors.orange,
                      ),
                    ),
                    title: Text(
                        'Journal',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      subtitle,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[50],
                      radius: 30,
                      child: Icon(
                        Icons.menu_book,
                        size: 35,
                        color: Colors.orange,
                      ),
                    ),
                    title: Text(
                      'Notes',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        subtitle,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[50],
                      radius: 30,
                      child: Icon(
                        Icons.grade,
                        size: 35,
                        color: Colors.orange,
                      ),
                    ),
                    title: Text(
                      'Gratitude',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        subtitle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                color: Colors.orange[300],
                size: 30,
              ),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment,
                color: Colors.deepPurple[300],
                size: 30,
              ),

              label: 'Daily'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.timeline,
                color: Colors.deepPurple[300],
                size: 30,
              ),
              label: 'Timeline'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
                color: Colors.deepPurple[300],
                size: 30,
              ),
              label: 'Explore',
          ),
        ],
        fixedColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPage,
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
