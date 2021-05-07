import 'package:flutter/material.dart';
import 'package:wtf/UI/app_bar.dart';
import 'package:wtf/UI/bot_button.dart';
import 'package:wtf/UI/bottom_bar.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget listItem(IconData icon, String title,
        {String substitle = "No events. Click Here to create one."}) {
      return ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).unselectedWidgetColor,
          ),
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(substitle),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedIconTheme: IconThemeData(
              color: Colors.cyan[600],
            ),
            selectedIconTheme: IconThemeData(
              color: Colors.lightBlue[800],
            )),
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        bottomAppBarColor: Colors.lightBlue[800],
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child:Icon(Icons.note_add_outlined),
          onPressed: () => {},
        ),
        appBar: AppBar(
          centerTitle: true,
          leading: Icon(Icons.menu_outlined),
          title: Text('Home'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(Icons.invert_colors_on_outlined),
            ),
          ],
        ),
        body: ListView(
          children: [
            BotButton(),
            Divider(),
            listItem(Icons.accessibility_new_rounded, "Travel"),
            Divider(),
            listItem(Icons.accessibility_new_rounded, 'Family'),
            Divider(),
            listItem(Icons.accessibility_new_rounded, 'Sports'),
            Divider(),
          ],
        ),
        bottomNavigationBar: JournalBottomBar(),
      ),
    );
  }
}
