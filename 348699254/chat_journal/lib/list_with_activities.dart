import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'create_new_page.dart';
import 'events_screen.dart';
import 'model/page.dart' as page;

class ChangeListViewBGColor extends StatefulWidget {
  final List<page.Page> pages;

  ChangeListViewBGColor(this.pages);

  @override
  _ChangeListViewBGColorState createState() => _ChangeListViewBGColorState();
}

class _ChangeListViewBGColorState extends State<ChangeListViewBGColor> {
  _ChangeListViewBGColorState();

  final List<String> _subtitle = [
    'No events. Click to create one',
    'No events. Click to create one',
    'No events. Click to create one',
  ];
  final List<page.Page> _pinPageList = [];
  int _selectedPageIndex = -1;
  int _selectedMenuIndex = -1;
  bool _isPined = false;
  int _pinCount = 0;

  void _onSelected(int index) async {
    setState(() => _selectedPageIndex = index);
    final value = await _pageEventListData(context);
    setState(() {
      if (value != false) {
        widget.pages[_selectedPageIndex].eventList.add(value);
      }
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventScreen(_selectedPageIndex)));
    Navigator.pushNamed(context, '/events', arguments: _selectedPageIndex);
  }

  Future<dynamic> _pageEventListData(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventScreen(_selectedPageIndex)));
    print(result);
    return Future.value(result);
  }

  void _onLongPagePress(int index) {
    setState(() => _selectedPageIndex = index);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Card(
                      child: _listWithMenuOptions(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _listWithMenuOptions() {
    return ListView(
      shrinkWrap: true,
      children: [
        _tileMenuOptions('Info', Icons.info, Colors.teal[500], 0),
        _tileMenuOptions(
            'Pin/Unpin Page', Icons.push_pin, Colors.green[500], 1),
        _tileMenuOptions(
            'Archive Page', Icons.archive_rounded, Colors.amber[500], 2),
        _tileMenuOptions('Edit Page', Icons.edit, Colors.blueAccent, 3),
        _tileMenuOptions('Delete page', Icons.delete, Colors.red[500], 4),
      ],
    );
  }

  ListTile _tileMenuOptions(
      String title, IconData icon, Color? color, int menuIndex) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      leading: Icon(
        icon,
        color: color,
      ),
      onTap: () => setState(() {
        _selectedMenuIndex = menuIndex;
        _doMenuOperationByIndex(_selectedMenuIndex);
      }),
    );
  }

  void _doMenuOperationByIndex(int index) {
    if (index == 0) {
      _showInfoAboutPage(_selectedPageIndex);
    } else if (index == 1) {
      _pinPages();
    } else if (index == 2) {
      print('Archive page operation');
    } else if (index == 3) {
      _editEditPage(_selectedPageIndex);
    } else if (index == 4) {
      _alertDeleteDialog(_selectedPageIndex);
    }
  }

  void _showInfoAboutPage(_selectedPageIndex) {
    final timeFormat = DateFormat('h:m a');
    final todayTimeInString = timeFormat
        .format(widget.pages[_selectedPageIndex].creationDate)
        .toString();
    var dialog = AlertDialog(
      title: ListTile(
        title: Text(
          widget.pages[_selectedPageIndex].name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 30,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: widget.pages[_selectedPageIndex].icon,
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          //height: 500,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Text(
                  'Created',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  'Today at $todayTimeInString',
                  style: const TextStyle(
                    color: Colors.black26,
                  ),
                ),
              ),
              const ListTile(
                title: Text(
                  'Last Event',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  'Today at ...',
                  style: TextStyle(
                    color: Colors.black26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(children: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.blue),
            onPressed: () {
              Navigator.of(context).pop(false); // Return true
            },
          ),
          const Text('Ok'),
        ]),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  void _pinPages() {
    setState(() {
      _isPined = !_isPined;
      while (_pinCount < 3) {
        if (_isPined == true) {
          _pinPageList.add(widget.pages[_selectedPageIndex]);
          _pinCount++;
        }
      }
    });
  }

  void _editEditPage(int pageIndex) async {
    final value = await _pageListEditData(context);
    setState(() {
      if (value != false) {
        widget.pages.removeAt(_selectedPageIndex);
        widget.pages.insert(_selectedPageIndex, value);
      }
    });
  }

  Future<dynamic> _pageListEditData(BuildContext context) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateNewPage()));
    print(result);
    return Future.value(result);
  }

  void _alertDeleteDialog(int pageIndex) {
    var dialog = AlertDialog(
      title: const Text('Delete Entry(s)?'),
      content: const FittedBox(
        child: Text('Are you sure you want to delete the 1 selected events?'),
      ),
      actions: [
        Row(children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                widget.pages.removeAt(_selectedPageIndex);
                _deleteToast();
                Navigator.of(context).pop(true);
              });
            },
          ),
          const Text('Delete'),
        ]),
        Row(children: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.blue),
            onPressed: () {
              Navigator.of(context).pop(false); // Return true
            },
          ),
          const Text('Cancel'),
        ]),
      ],
    );
    var futureValue = showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
    futureValue.then(
          (value) {
        setState(
              () {
            _selectedMenuIndex = -1;
            _selectedPageIndex = -1;
          },
        );
        print('Return value: $value'); // true/false
      },
    );
  }

  Future<bool?> _deleteToast() {
    return Fluttertoast.showToast(
        msg: 'Delete selected event',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.pages.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => Container(
        color: _selectedPageIndex == index ? Colors.lightGreen : Colors.white,
        child: _listTileForActivity(widget.pages[index].name,
            '_No events. Click to create one', widget.pages[index].icon, index),
      ),
    );
  }

  ListTile _listTileForActivity(
      String title, String subtitle, Icon icon, int index) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black26,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 30,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: icon,
                iconSize: 30,
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            if (_isPined == true)
              const Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.push_pin,
                    color: Colors.black54,
                  ), // change this children
                ),
              ),
          ],
        ),
        //radius: 10,
      ),
      onTap: () => _onSelected(index),
      onLongPress: () => _onLongPagePress(index),
    );
  }
}