import 'dart:async';

import 'package:flutter/material.dart';

import 'bottom_navigation.dart';
import 'create_new_page.dart';
import 'list_with_activities.dart';
import 'model/page.dart' as page;

StreamController<bool> isLightTheme = StreamController();

ThemeData lightThemeData = ThemeData(
  primarySwatch: Colors.teal,
  brightness: Brightness.light,
);

ThemeData darkThemeData = ThemeData(
  primarySwatch: Colors.deepPurple,
  brightness: Brightness.dark,
  bottomAppBarColor: Colors.amber,
  backgroundColor: Colors.black,
);

void main() {
  runApp(
    StreamBuilder<bool>(
      initialData: true,
      stream: isLightTheme.stream,
      builder: (context, snapshot) {
        return MaterialApp(
          theme: snapshot.data! ? lightThemeData : darkThemeData,
          debugShowCheckedModeBanner: false,
          title: 'Chat Journal App',
          initialRoute: '/',
          home: ChatJournalApp(),
        );
      },
    ),
  );
}

class ChatJournalApp extends StatefulWidget {
  final List<page.Page> _pageList = [];

  @override
  _ChatJournalAppState createState() => _ChatJournalAppState(_pageList);
}

class _ChatJournalAppState extends State<ChatJournalApp> {
  _ChatJournalAppState(List<page.Page> pageList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarHomeTitle(),
        leading: _appBarMenuButton(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.wb_incandescent_outlined),
            onPressed: () {
              isLightTheme.add(_themeValue);
              _themeValue = !_themeValue;
            },
          ),
        ],
      ),
      body: _bodyStructure(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final value = await _pageListData(context);
          setState(() {
            if (value != false) {
              widget._pageList.add(value);
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.brown),
        backgroundColor: Colors.amberAccent,
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Future<page.Page> _pageListData(BuildContext context) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateNewPage()));
    print(result);
    return Future.value(result);
  }

  Widget _bodyStructure() {
    var pages = widget._pageList.reversed;
    print(widget._pageList.length);
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: _questionnaireBotContainer(),
          ),
        ]),
        const Divider(height: 1),
        Expanded(
          child: ChangeListViewBGColor(pages.toList()),
        ),
      ],
    );
  }

  Widget _appBarHomeTitle() {
    return const Align(
      child: Text('Home'),
      alignment: Alignment.center,
    );
  }

  Widget _appBarMenuButton() {
    return IconButton(
      icon: const Icon(Icons.menu_outlined),
      onPressed: () {},
    );
  }

  bool _themeValue = false;

  Widget _appBarThemeButton() {
    return IconButton(
      icon: const Icon(Icons.wb_incandescent_outlined),
      onPressed: () {
        isLightTheme.add(_themeValue);
        _themeValue = !_themeValue;
      },
    );
  }

  Widget _questionnaireBotContainer() {
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
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
