import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color_theme.dart';
import '../edit_page/edit_page.dart';
import '../icons.dart';
import '../message_page/message_page.dart';
import '../page.dart';
import 'pages_cubit.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _usingLightTheme = true;

  @override
  void initState() {
    super.initState();
    _loadBool();
  }

  void _loadBool() async {
    final prefs = await SharedPreferences.getInstance();
    _usingLightTheme = (prefs.getBool('usingLightTheme') ?? true);
  }

  void _changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _usingLightTheme = !(prefs.getBool('usingLightTheme') ?? true);
    prefs.setBool('usingLightTheme', _usingLightTheme);
    ColorThemeData.appThemeStateKey.currentState!.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold;
  }

  Widget get _scaffold {
    return Scaffold(
      backgroundColor: ColorThemeData.of(context)!.mainColor,
      appBar: AppBar(
        backgroundColor: ColorThemeData.of(context)!.accentColor,
        title: const Text(
          'Chat Journal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _themeChangeButton,
        ],
      ),
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

  Widget get _bottomNavigationBar {
    return BottomNavigationBar(
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
  }

  Widget get _floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {
        final pageInfo = await Navigator.push(
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
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      tooltip: 'New page',
      child: const Icon(Icons.add),
    );
  }

  Widget get _body {
    return BlocProvider.of<PagesCubit>(context).state.isEmpty
        ? Center(
            child: Text(
              'No pages yet...',
              style: TextStyle(color: ColorThemeData.of(context)!.mainTextColor.withOpacity(0.5)),
            ),
          )
        : _gridView;
  }

  void _pageModalBottomSheet(context, int index) {
    final selected = BlocProvider.of<PagesCubit>(context).state[index];

    Widget _pinTile() {
      return ListTile(
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
          BlocProvider.of<PagesCubit>(context).pinPage(selected);
          Navigator.pop(context);
        },
      );
    }

    Widget _editTile() {
      return ListTile(
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
          final editState = await Navigator.push(
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
            BlocProvider.of<PagesCubit>(context).editPage(selected, editState.page);
          }
          Navigator.pop(context);
        },
      );
    }

    Widget _deleteTile() {
      return ListTile(
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
          BlocProvider.of<PagesCubit>(context).deletePage(selected);
          Navigator.pop(context);
        },
      );
    }

    Widget _infoTile() {
      Widget _alertDialog() {
        Widget _pageInfo() {
          return Row(
            children: [
              CircleAvatar(
                maxRadius: 20,
                foregroundColor: ColorThemeData.of(context)!.accentTextColor,
                backgroundColor: ColorThemeData.of(context)!.accentColor,
                child: Icon(
                  iconList[selected.iconIndex],
                ),
              ),
              Expanded(
                child: Text(
                  selected.title,
                  style: TextStyle(
                    color: ColorThemeData.of(context)!.accentTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }

        Widget _content() {
          Widget _infoTile(String header, DateTime? time) {
            return Column(
              children: [
                Text(
                  '$header:',
                  style: TextStyle(
                    color: ColorThemeData.of(context)!.mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(time!),
                  style: TextStyle(
                    color: ColorThemeData.of(context)!.mainTextColor,
                  ),
                ),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: _infoTile('Creation time', selected.creationTime),
              ),
              if (selected.lastEvent != null)
                _infoTile('Last event', selected.lastEvent!.creationTime),
            ],
          );
        }

        return AlertDialog(
          backgroundColor: ColorThemeData.of(context)!.mainColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              color: ColorThemeData.of(context)!.accentColor,
            ),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: _pageInfo(),
          ),
          content: _content(),
        );
      }

      return ListTile(
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
        onTap: () async {
          Navigator.pop(context);
          await showDialog(
            context: context,
            builder: (context) => _alertDialog(),
          );
        },
      );
    }

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
      },
    );
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
                builder: (context) => MessagePage(
                  page: BlocProvider.of<PagesCubit>(context).state[index],
                  title: '',
                ),
              ),
            );
            BlocProvider.of<PagesCubit>(context).updatePages();
          },
          onLongPress: () {
            _pageModalBottomSheet(context, index);
          },
          child: _gridViewItem(BlocProvider.of<PagesCubit>(context).state[index]),
        );
      },
      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
    );
  }

  Widget _gridViewItem(JournalPage page) {
    Widget _header() {
      return Container(
        decoration: BoxDecoration(
          color: ColorThemeData.of(context)!.accentColor,
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              iconList[page.iconIndex],
              color: ColorThemeData.of(context)!.accentTextColor,
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
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget _content() {
      return Container(
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
    }

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
          Radius.circular(35),
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
