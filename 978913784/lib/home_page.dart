import 'dart:math';

import 'package:chat_journal/edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  final List<JournalPage> unpinnedPages = <JournalPage>[
    JournalPage('Really big title text', Icons.whatshot)
      ..addEvent(Event('My new note')),
    JournalPage('Notes', Icons.notes)
      ..addEvent(Event(
          'Помоги! Покажи мне дорогу через травы, кустарники, чащу леса. '
          'Я за кроной из своих сомнений солнца не вижу, но может быть если... '
          'Если найду я тайные тропы, если найду я смысл, если в слова смогу '
          'облачить блуждающую свою мысль')),
    JournalPage('Food', Icons.fastfood),
    JournalPage('Flight', Icons.airplanemode_active)
      ..addEvent(Event('My new note')),
    JournalPage('Спорт', Icons.sports_football),
    JournalPage('家族', Icons.family_restroom)..addEvent(Event('My new note')),
  ];

  final List<JournalPage> pinnedPages = <JournalPage>[
    JournalPage('Work', Icons.work_outlined)
      ..addEvent(Event('My new note'))
      ..isPinned = true,
  ];

  List<JournalPage> get pages => [
        ...pinnedPages,
        ...unpinnedPages,
      ];

  void sortPinned() => unpinnedPages.sort((a, b) {
        final firstEvent = b.lastEvent;
        final secondEvent = a.lastEvent;
        if (firstEvent != null && secondEvent != null) {
          return firstEvent.creationTime.compareTo(secondEvent.creationTime);
        } else if (firstEvent == null && secondEvent == null) {
          return 0;
        } else if (secondEvent == null) {
          return 1;
        } else {
          return -1;
        }
      });

  @override
  Widget build(BuildContext context) {
    sortPinned();
    return _scaffold;
  }

  Widget get _scaffold => Scaffold(
        backgroundColor: AppThemeData.of(context).mainColor,
        appBar: AppBar(
          backgroundColor: AppThemeData.of(context).accentColor,
          title: Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            _themeChangeButton,
          ],
        ),
        drawer: drawer,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: _body,
      );

  Widget get _themeChangeButton => IconButton(
        icon: Icon(
          AppThemeData.usingLightTheme
              ? Icons.wb_sunny_outlined
              : Icons.bedtime_outlined,
        ),
        onPressed: () => setState(() {
          AppThemeData.usingLightTheme = !AppThemeData.usingLightTheme;
          AppThemeData.appThemeStateKey.currentState.setState(() {});
        }),
      );

  Widget get drawer => Drawer(
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

  Widget get floatingActionButton => FloatingActionButton(
        onPressed: () async {
          final pageToAdd = JournalPage('New page', Icons.notes);

          var isToAdd = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPage(
                    page: pageToAdd,
                    title: 'New page',
                  ),
                ),
              ) ??
              false;
          setState(() {
            if (isToAdd) {
              unpinnedPages.add(pageToAdd);
            }
          });
        },
        backgroundColor: AppThemeData.of(context).accentColor,
        tooltip: 'New page',
        child: Icon(Icons.add),
      );

  Widget get _body => pages.isEmpty
      ? Center(
          child: Text(
            'No pages yet...',
            style: TextStyle(
                color: AppThemeData.of(context).mainTextColor.withOpacity(0.5)),
          ),
        )
      : gridView;

  void _pageModalBottomSheet(context, int index) {
    var selected = pages[index];

    Widget _pinTile() => ListTile(
        leading: Transform.rotate(
          angle: 45 * pi / 180,
          child: Icon(
            Icons.push_pin_outlined,
            color: AppThemeData.of(context).mainTextColor,
          ),
        ),
        title: Text(
          selected.isPinned ? 'Unpin' : 'Pin',
          style: TextStyle(
            color: AppThemeData.of(context).mainTextColor,
          ),
        ),
        onTap: () async {
          if (selected.isPinned) {
            setState(() {
              selected.isPinned = false;
              pinnedPages.remove(selected);
              unpinnedPages.add(selected);
            });
          } else {
            setState(() {
              selected.isPinned = true;
              pinnedPages.insert(0, selected);
              unpinnedPages.remove(selected);
            });
          }
          Navigator.pop(context);
        });

    Widget _editTile() => ListTile(
        leading: Icon(
          Icons.edit_outlined,
          color: AppThemeData.of(context).mainTextColor,
        ),
        title: Text(
          'Edit',
          style: TextStyle(
            color: AppThemeData.of(context).mainTextColor,
          ),
        ),
        onTap: () async {
          final pageToEdit = JournalPage(pages[index].title, pages[index].icon);

          var isToEdit = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPage(
                    page: pageToEdit,
                    title: 'Edit',
                  ),
                ),
              ) ??
              false;
          setState(() {
            if (isToEdit) {
              pages[index].title = pageToEdit.title;
              pages[index].icon = pageToEdit.icon;
            }
          });
          Navigator.pop(context);
        });

    Widget _deleteTile() => ListTile(
        leading: Icon(
          Icons.delete_outlined,
          color: AppThemeData.of(context).mainTextColor,
        ),
        title: Text(
          'Delete',
          style: TextStyle(
            color: AppThemeData.of(context).mainTextColor,
          ),
        ),
        onTap: () {
          setState(
            () => selected.isPinned
            ? pinnedPages.remove(selected)
                : unpinnedPages.remove(selected),
          );
          Navigator.pop(context);
        });

    Widget _infoTile() => ListTile(
        leading: Icon(
          Icons.info_outline,
          color: AppThemeData.of(context).mainTextColor,
        ),
        title: Text(
          'Info',
          style: TextStyle(
            color: AppThemeData.of(context).mainTextColor,
          ),
        ),
        onTap: () {
          setState(
            () => pages.removeAt(index),
          );
          Navigator.pop(context);
        });

    showModalBottomSheet(
        context: context,
        backgroundColor: AppThemeData.of(context).mainColor,
        builder: (context) {
          return Wrap(
            children: <Widget>[
              _pinTile(),
              _editTile(),
              _deleteTile(),
              _infoTile(),
            ],
          );
        });
  }

  Widget get gridView {
    return StaggeredGridView.extentBuilder(
      maxCrossAxisExtent: 300,
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
            _pageModalBottomSheet(context, index);
          },
          child: _gridViewItem(pages[index]),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
    );
  }

  Widget _gridViewItem(JournalPage page) {
    Widget _header() => Container(
          decoration: BoxDecoration(
            color: AppThemeData.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                page.icon,
                color: AppThemeData.of(context).accentTextColor,
              ),
              Expanded(
                child: Text(
                  page.title,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppThemeData.of(context).accentTextColor),
                ),
              ),
              if (page.isPinned)
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                      angle: 45 * pi / 180,
                      child: Icon(
                        Icons.push_pin_outlined,
                        color: AppThemeData.of(context).accentTextColor,
                      )),
                ),
            ],
          ),
        );

    Widget _content() => Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(10),
          child: page.lastEvent == null
              ? Center(
                  child: Text(
                    'No events yet...',
                    style: TextStyle(
                      color: AppThemeData.of(context)
                          .mainTextColor
                          .withOpacity(0.5),
                    ),
                  ),
                )
              : Text(
                  page.lastEvent.description,
                  style: TextStyle(
                    color: AppThemeData.of(context).mainTextColor,
                  ),
                ),
        );

    return Container(
      margin: EdgeInsets.all(3),
      child: Column(
        children: [
          _header(),
          _content(),
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
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
    );
  }
}
