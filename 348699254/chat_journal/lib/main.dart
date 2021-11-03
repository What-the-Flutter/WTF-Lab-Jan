import 'package:flutter/material.dart';

import 'bottom_navigation.dart';
import 'events_screen.dart';
import 'list_with_activities.dart';

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
      initialRoute: '/',
      routes: {
        '/events': (context) => EventScreen(),
        /*'/daily': (context) => DailyScreen(),
        '/timeline': (context) => TimelineScreen(),
        '/explore': (context) => ExploreScreen(),*/
      },
      home: Scaffold(
        appBar: AppBar(
          title: _createAppBarTitle(),
          leading: _buildAppBarLeftButton(),
          actions: <Widget>[
            _buildAppBarRightButton(),
          ],
        ),
        body: _bodyStructure(),
        floatingActionButton: _createFloatingActionButton(),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}

Widget _createAppBarTitle() {
  return const Align(
    child: Text('Home'),
    alignment: Alignment.center,
  );
}

Widget _buildAppBarLeftButton() {
  return IconButton(
    icon: const Icon(Icons.menu_outlined),
    onPressed: () => print('Click on menu outlined button'),
  );
}

Widget _buildAppBarRightButton() {
  return IconButton(
    icon: const Icon(Icons.wb_incandescent_outlined),
    onPressed: () => print('Click on incandescent outlined button'),
  );
}

Widget _buildContainer() {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.adb),
          const Text('   Questionnaire Bot'),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
    ),
  );
}

Widget _bodyStructure() {
  return Column(
    children: <Widget>[
      Row(children: <Widget>[
        Expanded(
          child: _buildContainer(),
        ),
      ]),
      const Divider(height: 1),
      Expanded(
        child: ChangeListViewBGColor(),
      ),
    ],
  );
}

Widget _createFloatingActionButton() {
  return FloatingActionButton(
    onPressed: () {
      // Add your onPressed code here!
    },
    child: const Icon(Icons.add, color: Colors.brown),
    backgroundColor: Colors.amberAccent,
  );
}
