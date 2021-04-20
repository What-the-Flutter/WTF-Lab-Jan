import 'package:flutter/material.dart';

//import './floating_action_bar.dart';
import './event_chat.dart';
import 'bottom_bar.dart';

Color colorMain = Colors.deepPurple[200];
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorMain,
        title: Center(
          child: const Text('Home'),
        ),
      ),
      body: Chat(),           //ItemsList(),
     // floatingActionButton: FloatingActionBar(),
      bottomNavigationBar: BottomBar(),
    );
  }
}
