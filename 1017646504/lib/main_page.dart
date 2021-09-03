import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'color_theme.dart';
import 'edit_page.dart';
import 'message_page.dart';
import 'page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<JournalPage> unpinnedPages = <JournalPage>[
    JournalPage('Fire', Icons.whatshot, creationTime: DateTime.now())
      ..addEvent(Event('My new note')),
    JournalPage('Notes', Icons.notes, creationTime: DateTime.now())..addEvent(Event('First Node')),
    JournalPage('Food', Icons.fastfood, creationTime: DateTime.now()),
    JournalPage('Flight', Icons.airplanemode_active, creationTime: DateTime.now())
      ..addEvent(Event('My new note')),
    JournalPage('Sport', Icons.sports_football, creationTime: DateTime.now()),
    JournalPage('Family', Icons.family_restroom, creationTime: DateTime.now())
      ..addEvent(Event('My new note')),
  ];

  final List<JournalPage> pinnedPages = <JournalPage>[
    JournalPage('Work', Icons.work_outlined, creationTime: DateTime.now())
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
        backgroundColor: ColorThemeData.of(context)!.mainColor,
        appBar: AppBar(
          backgroundColor: ColorThemeData.of(context)!.accentColor,
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            _themeChangeButton,
          ],
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: _body,
      );

  Widget get _themeChangeButton => IconButton(
        icon: Icon(
          ColorThemeData.usingLightTheme ? Icons.wb_sunny_outlined : Icons.bedtime_outlined,
        ),
        onPressed: () => setState(() {
          ColorThemeData.usingLightTheme = !ColorThemeData.usingLightTheme;
          ColorThemeData.appThemeStateKey.currentState!.setState(() {});
        }),
      );

  Widget get bottomNavigationBar => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: 0,
        backgroundColor: ColorThemeData.of(context)!.accentColor,
        selectedItemColor: ColorThemeData.of(context)!.accentTextColor,
        unselectedItemColor: ColorThemeData.of(context)!.accentTextColor.withOpacity(0.3),
      );

  Widget get floatingActionButton => FloatingActionButton(
        onPressed: () async {
          final pageToAdd = JournalPage('New page', Icons.notes, creationTime: DateTime.now());

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
        backgroundColor: ColorThemeData.of(context)!.accentColor,
        tooltip: 'New page',
        child: const Icon(Icons.add),
      );

  Widget get _body => pages.isEmpty
      ? Center(
          child: Text(
            'No pages yet...',
            style: TextStyle(color: ColorThemeData.of(context)!.mainTextColor.withOpacity(0.5)),
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
            color: ColorThemeData.of(context)!.mainTextColor,
          ),
        ),
        title: Text(
          selected.isPinned ? 'Unpin' : 'Pin',
          style: TextStyle(
            color: ColorThemeData.of(context)!.mainTextColor,
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
          color: ColorThemeData.of(context)!.mainTextColor,
        ),
        title: Text(
          'Edit',
          style: TextStyle(
            color: ColorThemeData.of(context)!.mainTextColor,
          ),
        ),
        onTap: () async {
          final pageToEdit =
              JournalPage(pages[index].title, pages[index].icon, creationTime: DateTime.now());

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
          color: ColorThemeData.of(context)!.mainTextColor,
        ),
        title: Text(
          'Delete',
          style: TextStyle(
            color: ColorThemeData.of(context)!.mainTextColor,
          ),
        ),
        onTap: () {
          setState(
            () => selected.isPinned ? pinnedPages.remove(selected) : unpinnedPages.remove(selected),
          );
          Navigator.pop(context);
        });

    Widget _infoTile() => ListTile(
        leading: Icon(
          Icons.info_outline,
          color: ColorThemeData.of(context)!.mainTextColor,
        ),
        title: Text(
          'Info',
          style: TextStyle(
            color: ColorThemeData.of(context)!.mainTextColor,
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
        backgroundColor: ColorThemeData.of(context)!.mainColor,
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
                  builder: (context) => MessagePage(
                        page: pages[index],
                        title: '',
                      )),
            );
            setState(() {});
          },
          onLongPress: () {
            _pageModalBottomSheet(context, index);
          },
          child: _gridViewItem(pages[index]),
        );
      },
      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
    );
  }

  Widget _gridViewItem(JournalPage page) {
    Widget _header() => Container(
          decoration: BoxDecoration(
            color: ColorThemeData.of(context)!.accentColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                page.icon,
                color: ColorThemeData.of(context)!.accentTextColor,
              ),
              Expanded(
                child: Text(
                  page.title,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorThemeData.of(context)!.accentTextColor),
                ),
              ),
              if (page.isPinned)
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                      angle: 45 * pi / 180,
                      child: Icon(
                        Icons.push_pin_outlined,
                        color: ColorThemeData.of(context)!.accentTextColor,
                      )),
                ),
            ],
          ),
        );

    Widget _content() => Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: page.lastEvent == null
              ? Center(
                  child: Text(
                    'No events yet...',
                    style: TextStyle(
                      color: ColorThemeData.of(context)!.mainTextColor.withOpacity(0.5),
                    ),
                  ),
                )
              : Text(
                  page.lastEvent!.description,
                  style: TextStyle(
                    color: ColorThemeData.of(context)!.mainTextColor,
                  ),
                ),
        );

    return Container(
      margin: const EdgeInsets.all(3),
      child: Column(
        children: [
          _header(),
          _content(),
        ],
      ),
      decoration: BoxDecoration(
        color: ColorThemeData.of(context)!.mainColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorThemeData.of(context)!.shadowColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
    );
  }
}
