import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../edit_page/edit_page.dart';
import '../event_page/event_page.dart';
import '../icon_list.dart';
import '../page.dart';
import 'pages_cubit.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _usingLightTheme = true;

  @override
  void initState() {
    super.initState();
    _loadBool();
  }

  void _loadBool() async {
    var prefs = await SharedPreferences.getInstance();
    _usingLightTheme = (prefs.getBool('usingLightTheme') ?? true);
  }

  void _changeTheme() async {
    var prefs = await SharedPreferences.getInstance();
    _usingLightTheme = !(prefs.getBool('usingLightTheme') ?? true);
    prefs.setBool('usingLightTheme', _usingLightTheme);
      AppThemeData.appThemeStateKey.currentState.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold;
  }

  Widget get _scaffold {
    return Scaffold(
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
      drawer: _drawer,
      bottomNavigationBar: _bottomNavigationBar,
      floatingActionButton: _floatingActionButton,
      body: BlocBuilder<PagesCubit, List<JournalPage>>(
        builder: (context, state) {
          return _body;
        },
      ),
    );
  }

  Widget get _themeChangeButton {
    return IconButton(
      icon: Icon(
        _usingLightTheme ? Icons.wb_sunny_outlined : Icons.bedtime_outlined,
      ),
      onPressed: _changeTheme,
    );
  }

  Widget get _drawer {
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

  Widget get _bottomNavigationBar {
    return BottomNavigationBar(
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
  }

  Widget get _floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {
        var pageInfo = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPage(
              page: JournalPage('New page', 0),
              title: 'New page',
            ),
          ),
        );
        if (pageInfo.isAllowedToSave) {
          BlocProvider.of<PagesCubit>(context).addPage(pageInfo.page);
        }
      },
      backgroundColor: AppThemeData.of(context).accentColor,
      tooltip: 'New page',
      child: Icon(Icons.add),
    );
  }

  Widget get _body {
    return BlocProvider.of<PagesCubit>(context).state.isEmpty
        ? Center(
            child: Text(
              'No pages yet...',
              style: TextStyle(
                  color:
                      AppThemeData.of(context).mainTextColor.withOpacity(0.5)),
            ),
          )
        : _gridView;
  }

  void _pageModalBottomSheet(context, int index) {
    var selected = BlocProvider.of<PagesCubit>(context).state[index];

    Widget _pinTile() {
      return ListTile(
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
            BlocProvider.of<PagesCubit>(context).pinPage(selected);
            Navigator.pop(context);
          });
    }

    Widget _editTile() {
      return ListTile(
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
            var editState = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(
                      page: JournalPage(selected.title, selected.iconIndex),
                      title: 'Edit',
                    ),
                  ),
                ) ??
                false;
            if (editState.isAllowedToSave) {
              BlocProvider.of<PagesCubit>(context)
                  .editPage(selected, editState.page);
            }
            Navigator.pop(context);
          });
    }

    Widget _deleteTile() {
      return ListTile(
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
            BlocProvider.of<PagesCubit>(context).deletePage(selected);
            Navigator.pop(context);
          });
    }

    Widget _infoTile() {
      Widget _alertDialog() {
        Widget _pageInfo() {
          return Row(
            children: [
              CircleAvatar(
                maxRadius: 20,
                foregroundColor: AppThemeData.of(context).accentTextColor,
                backgroundColor: AppThemeData.of(context).accentColor,
                child: Icon(
                  iconList[selected.iconIndex],
                ),
              ),
              Expanded(
                child: Text(
                  selected.title,
                  style: TextStyle(
                    color: AppThemeData.of(context).accentTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }

        Widget _content() {
          Widget _infoTile(String header, DateTime time) {
            return Column(
              children: [
                Text(
                  '$header:',
                  style: TextStyle(
                    color: AppThemeData.of(context).mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(time),
                  style: TextStyle(
                    color: AppThemeData.of(context).mainTextColor,
                  ),
                ),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: _infoTile('Creation time', selected.creationTime),
              ),
              if (selected.lastEvent != null)
                _infoTile('Last event', selected.lastEvent.creationTime),
            ],
          );
        }

        return AlertDialog(
          backgroundColor: AppThemeData.of(context).mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: AppThemeData.of(context).accentColor,
            ),
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: _pageInfo(),
          ),
          content: _content(),
        );
      }

      return ListTile(
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
          onTap: () async {
            Navigator.pop(context);
            await showDialog(
              context: context,
              builder: (context) => _alertDialog(),
            );
          });
    }

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

  Widget get _gridView {
    return StaggeredGridView.extentBuilder(
      maxCrossAxisExtent: 300,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: BlocProvider.of<PagesCubit>(context).state.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventPage(
                      page: BlocProvider.of<PagesCubit>(context).state[index])),
            );
            BlocProvider.of<PagesCubit>(context).updatePages();
          },
          onLongPress: () {
            _pageModalBottomSheet(context, index);
          },
          child:
              _gridViewItem(BlocProvider.of<PagesCubit>(context).state[index]),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
    );
  }

  Widget _gridViewItem(JournalPage page) {
    Widget _header() {
      return Container(
        decoration: BoxDecoration(
          color: AppThemeData.of(context).accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              iconList[page.iconIndex],
              color: AppThemeData.of(context).accentTextColor,
            ),
            Expanded(
              child: Text(
                page.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    }

    Widget _content() {
      return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(10),
        child: page.lastEvent == null
            ? Center(
                child: Text(
                  'No events yet...',
                  style: TextStyle(
                    color:
                        AppThemeData.of(context).mainTextColor.withOpacity(0.5),
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
    }

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
          Radius.circular(5),
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
