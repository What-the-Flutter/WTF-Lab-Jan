import 'package:chat_journal/edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'event_page.dart';
import 'page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<JournalPage> pages = <JournalPage>[
    JournalPage('Notes', Icons.notes)
      ..addEvent(Event(
          'Помоги! Покажи мне дорогу через травы, кустарники, чащу леса. '
          'Я за кроной из своих сомнений солнца не вижу, но может быть если... '
          'Если найду я тайные тропы, если найду я смысл, если в слова смогу '
          'облачить блуждающую свою мысль')),
    JournalPage('Food', Icons.fastfood),
    JournalPage('Flight', Icons.airplanemode_active)
      ..addEvent(Event('My new note')),
    JournalPage('Sport', Icons.sports_football),
    JournalPage('Family', Icons.family_restroom)
      ..addEvent(Event('My new note')),
  ];

  // final List<JournalPage> pages = [];

  @override
  Widget build(BuildContext context) {
    return _scaffold;
  }

  Widget get _scaffold => Scaffold(
        backgroundColor: AppThemeData.of(context).mainColor,
        appBar: AppBar(
          backgroundColor: AppThemeData.of(context).accentColor,
          title: Text('Home'),
          actions: [
            IconButton(
                icon: Icon(
                  AppThemeData.usingLightTheme
                      ? Icons.wb_sunny_outlined
                      : Icons.bedtime_outlined,
                ),
                onPressed: () {
                  setState(() {
                    AppThemeData.usingLightTheme =
                        !AppThemeData.usingLightTheme;
                    AppThemeData.appThemeStateKey.currentState.setState(() {});
                  });
                }),
          ],
        ),
        drawer: drawer,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: _body,
      );

  Widget get _body => pages.isEmpty
      ? Center(
          child: Text(
            'No pages yet...',
            style: TextStyle(
                color: AppThemeData.of(context)
                    .mainTextColor
                    .withOpacity(0.5)),
          ),
        )
      : gridView;

  Widget get drawer {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppThemeData.of(context).mainColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Item'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget get bottomNavigationBar => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
        ],
        currentIndex: 0,
        backgroundColor: AppThemeData.of(context).accentColor,
        selectedItemColor: AppThemeData.of(context).accentTextColor,
        unselectedItemColor:
            AppThemeData.of(context).accentTextColor.withOpacity(0.3),
      );

  Widget get floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {
        JournalPage pageToAdd = JournalPage('New page', Icons.notes);

        var isToAdd =  await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPage(page: pageToAdd),
          ),
        ) ?? false;
        setState(() {
          if (isToAdd) {
            pages.add(pageToAdd);
          }
        });
      },
      backgroundColor: AppThemeData.of(context).accentColor,
      tooltip: 'New page',
      child: Icon(Icons.add),
    );
  }

  void _pageModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Edit'),
                  onTap: () => {}),
              ListTile(
                leading: Icon(Icons.delete_outlined),
                title: Text('Delete'),
                onTap: () => {},
              ),
            ],
          );
        });
  }

  GridView get gridView {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventPage(page: pages[index])),
            );
            setState(() {});
          },
          onLongPress: () {
            _pageModalBottomSheet(context);
          },
          child: _gridViewItem(index),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 0),
    );
  }

  Widget _gridViewItem(int index) => Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppThemeData.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    pages[index].icon,
                    color: AppThemeData.of(context).accentTextColor,
                  ),
                  Text(
                    pages[index].title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemeData.of(context).accentTextColor),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  pages[index].lastEvent == null
                      ? 'No events yet...'
                      : pages[index].lastEvent.description,
                  style: TextStyle(
                    color: AppThemeData.of(context).mainTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: AppThemeData.of(context).mainColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppThemeData.of(context).shadowColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(2, 2),
            ),
          ],
        ),
      );
}
