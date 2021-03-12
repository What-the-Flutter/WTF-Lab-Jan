import 'dart:math';

import 'package:chat_journal/settings_page/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import '../app_theme_cubit.dart';
import '../app_theme_state.dart';
import '../data/icon_list.dart';
import '../edit_page/edit_page.dart';
import '../entity/page.dart';
import '../event_page/event_page.dart';
import 'pages_cubit.dart';

class HomePage extends StatelessWidget {
  final AppThemeState _appThemeState;

  HomePage(this._appThemeState);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PagesCubit>(context).initialize();
    return _scaffold(context);
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: _appThemeState.mainColor,
      appBar: AppBar(
        backgroundColor: _appThemeState.accentColor,
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _themeChangeButton(context),
        ],
      ),
      drawer: _drawer(context),
      bottomNavigationBar: _bottomNavigationBar,
      floatingActionButton: _floatingActionButton(context),
      body: BlocBuilder<PagesCubit, List<JournalPage>>(
        builder: (context, state) {
          return _body(context);
        },
      ),
    );
  }

  Widget _themeChangeButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        _appThemeState.usingLightTheme
            ? Icons.wb_sunny_outlined
            : Icons.bedtime_outlined,
      ),
      onPressed: BlocProvider.of<AppThemeCubit>(context).changeTheme,
    );
  }

  Widget _drawer(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: _appThemeState.mainColor),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: _appThemeState.accentColor,
              ),
              child: Text(
                DateFormat('MMM d, yyyy').format(DateTime.now()),
                style: TextStyle(
                  color: _appThemeState.accentTextColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: _appThemeState.mainTextColor,
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: _appThemeState.mainTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
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
      backgroundColor: _appThemeState.accentColor,
      selectedItemColor: _appThemeState.accentTextColor,
      unselectedItemColor: _appThemeState.accentTextColor.withOpacity(0.3),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        var pageInfo = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPage(
              JournalPage('New page', 0),
              'New page',
              _appThemeState,
            ),
          ),
        );
        if (pageInfo.isAllowedToSave) {
          BlocProvider.of<PagesCubit>(context).addPage(pageInfo.page);
          BlocProvider.of<PagesCubit>(context).state.forEach((element) {});
        }
      },
      backgroundColor: _appThemeState.accentColor,
      tooltip: 'New page',
      child: Icon(Icons.add),
    );
  }

  Widget _body(BuildContext context) {
    return BlocProvider.of<PagesCubit>(context).state.isEmpty
        ? Center(
            child: Text(
              'No pages yet...',
              style: TextStyle(
                  color: _appThemeState.mainTextColor.withOpacity(0.5)),
            ),
          )
        : _gridView(context);
  }

  void _pageModalBottomSheet(BuildContext context, int index) {
    var selected = BlocProvider.of<PagesCubit>(context).state[index];

    Widget _pinTile() {
      return ListTile(
          leading: Transform.rotate(
            angle: 45 * pi / 180,
            child: Icon(
              Icons.push_pin_outlined,
              color: _appThemeState.mainTextColor,
            ),
          ),
          title: Text(
            selected.isPinned ? 'Unpin' : 'Pin',
            style: TextStyle(
              color: _appThemeState.mainTextColor,
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
            color: _appThemeState.mainTextColor,
          ),
          title: Text(
            'Edit',
            style: TextStyle(
              color: _appThemeState.mainTextColor,
            ),
          ),
          onTap: () async {
            var editState = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(
                      JournalPage(selected.title, selected.iconIndex),
                      'Edit',
                      _appThemeState,
                    ),
                  ),
                ) ??
                false;
            if (editState.isAllowedToSave) {
              BlocProvider.of<PagesCubit>(context)
                  .editPage(selected, editState._page);
            }
            Navigator.pop(context);
          });
    }

    Widget _deleteTile() {
      return ListTile(
          leading: Icon(
            Icons.delete_outlined,
            color: _appThemeState.mainTextColor,
          ),
          title: Text(
            'Delete',
            style: TextStyle(
              color: _appThemeState.mainTextColor,
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
                foregroundColor: _appThemeState.accentTextColor,
                backgroundColor: _appThemeState.accentColor,
                child: Icon(
                  iconList[selected.iconIndex],
                ),
              ),
              Expanded(
                child: Text(
                  selected.title,
                  style: TextStyle(
                    color: _appThemeState.accentTextColor,
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
                    color: _appThemeState.mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(time),
                  style: TextStyle(
                    color: _appThemeState.mainTextColor,
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
          backgroundColor: _appThemeState.mainColor,
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
              color: _appThemeState.accentColor,
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
            color: _appThemeState.mainTextColor,
          ),
          title: Text(
            'Info',
            style: TextStyle(
              color: _appThemeState.mainTextColor,
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
        backgroundColor: _appThemeState.mainColor,
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

  Widget _gridView(BuildContext context) {
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
                        BlocProvider.of<PagesCubit>(context).state[index],
                        _appThemeState,
                      )),
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
          color: _appThemeState.accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              iconList[page.iconIndex],
              color: _appThemeState.accentTextColor,
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
                    color: _appThemeState.accentTextColor),
              ),
            ),
            if (page.isPinned)
              Align(
                alignment: Alignment.centerRight,
                child: Transform.rotate(
                    angle: 45 * pi / 180,
                    child: Icon(
                      Icons.push_pin_outlined,
                      color: _appThemeState.accentTextColor,
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
                    color: _appThemeState.mainTextColor.withOpacity(0.5),
                  ),
                ),
              )
            : Text(
                page.lastEvent.description,
                style: TextStyle(
                  color: _appThemeState.mainTextColor,
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
        color: _appThemeState.mainColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: _appThemeState.shadowColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
    );
  }
}
