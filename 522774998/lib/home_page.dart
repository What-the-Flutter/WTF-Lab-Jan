import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_dialog_page.dart';
import 'event_page.dart';
import 'themes.dart';

class ListItem {
  final IconData _icon;
  final String _name;
  final String _time;
  final int _id;

  bool isPinned;

  ListItem(this._icon, this._name, this._id, this._time, this.isPinned);

  String get name => _name;

  int get id => _id;

  IconData get icon => _icon;

  String get time => _time;
}

class ListItemIcon<T> {
  bool isSelected;
  IconData iconData;

  ListItemIcon(this.iconData, {this.isSelected = false});
}

List<IconData> iconsList = [
  Icons.fastfood,
  Icons.music_note,
  Icons.local_cafe,
  Icons.work,
  Icons.insert_emoticon,
  Icons.place,
  Icons.weekend,
  Icons.spa,
  Icons.local_movies,
  Icons.local_shipping,
  Icons.book_sharp,
  Icons.grade,
  Icons.nature_people
];
List<ListItemIcon<IconData>> icons = [];
ThemeData myTheme = lightTheme;
List<ListItem> dialogs = <ListItem>[
  ListItem(Icons.book_sharp, 'Journal', 0,
      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()), false),
  ListItem(Icons.grade, 'Notes', 1,
      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()), false),
  ListItem(Icons.nature_people, 'Gratitude', 2,
      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()), false),
];

class HomePage extends StatefulWidget {
  final String title;
  final String subtitle;
  final ThemeData theme;

  HomePage({Key key, this.title, this.subtitle, this.theme}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isLightTheme = true;

  void addIcons() {
    setState(() {
      for (var i = 0; i < iconsList.length; i++) {
        icons.add(ListItemIcon<IconData>(iconsList[i]));
        icons[i].isSelected = false;
      }
      icons[0].isSelected = true;
    });
  }

  void changeTheme() {
    setState(() {
      if (isLightTheme == true) {
        isLightTheme = false;
        myTheme = darkTheme;
      } else {
        isLightTheme = true;
        myTheme = lightTheme;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      home: Scaffold(
        appBar: _appBar,
        body: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              color: isLightTheme ? Colors.deepPurple : Colors.black,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: isLightTheme ? Colors.white : Colors.black,
              ),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.orange[50],
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.help,
                              size: 35,
                              color: Colors.orange,
                            ),
                            Text(
                              'Questionnaire Bot',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 500,
                    child: Column(
                      children: <Widget>[
                        dialogsList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomBar(),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () async {
              addIcons();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDialogPage(),
                ),
              );
              setState(() {});
            },
            tooltip: 'Add new dialog',
            child: Icon(
              Icons.add,
            ),
            backgroundColor: Colors.orange,
          ),
        ),
      ),
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Container(
        alignment: Alignment.center,
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
      ),
      leading: Icon(
        Icons.menu,
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 30),
          child: IconButton(
            onPressed: () {
              changeTheme();
            },
            icon: Icon(Icons.invert_colors),
          ),
        ),
      ],
    );
  }

  Widget dialogPage(ListItem dialog) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EventListPage(title: dialog._name, theme: myTheme),
            ),
          );
        },
        onLongPress: () {
          _settingModalBottomSheet(context, dialog);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange[50],
                radius: 30,
                child: Icon(
                  dialog.isPinned ? Icons.push_pin : dialog._icon,
                  size: 35,
                  color: Colors.orange,
                ),
              ),
              title: Text(
                dialog._name,
                style: TextStyle(
                    fontSize: 20,
                    color: isLightTheme ? Colors.black : Colors.white),
              ),
            ),
          ),
          color: isLightTheme ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget dialogsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: dialogs.length,
        itemBuilder: (context, i) {
          ListItem data;
          data = dialogs[i];
          return dialogPage(data);
        },
      ),
    );
  }

  void _settingModalBottomSheet(context, ListItem dialog) {
    showModalBottomSheet(
      context: context,
      builder: (bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.orange,
                ),
                title: Text(
                  'Edit',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  for (var i = 0; i < icons.length; i++) {
                    icons[i].isSelected = false;
                  }
                  icons[editingIcon(dialog)].isSelected = true;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDialogPage(
                        controller: dialog.name,
                        operation: 'edit',
                        editingDialog: editingDialog(dialog),
                        editingIcon: editingIcon(dialog),
                      ),
                    ),
                  );
                  setState(() {});
                  Navigator.of(context).pop();
                }),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.orange,
              ),
              title: Text(
                'Delete',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                deleteDialog(context, dialog);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.orange,
              ),
              title: Text(
                'Info',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Widget okButton = TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                );
                var alert = AlertDialog(
                  title: Text(dialog.name),
                  content: Text('Created \n${dialog.time}'),
                  actions: [
                    okButton,
                  ],
                );
                showDialog(
                  context: context,
                  builder: (context) {
                    return alert;
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.push_pin,
                color: Colors.orange,
              ),
              title: Text(
                'Pin/Unpin',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                if (dialog.isPinned == false) {
                  pinDialog(context, dialog);
                } else {
                  unpinDialog(context, dialog);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void unpinDialog(dynamic context, ListItem dialog) {
    setState(() {
      dialog.isPinned = false;
      for (var i = 0; i < dialogs.length; i++) {
        if (dialogs[i].id == dialog.id) {
          dialogs.removeAt(i);
        }
      }
      dialogs.insert(dialog.id, dialog);
    });
    Navigator.pop(context);
  }

  void pinDialog(dynamic context, ListItem dialog) {
    setState(() {
      for (var i = 0; i < dialogs.length; i++) {
        dialogs[i].isPinned = false;
      }
      dialog.isPinned = true;
      for (var i = 0; i < dialogs.length; i++) {
        if (dialogs[i].id == dialog.id) {
          dialogs.removeAt(i);
        }
      }
      dialogs.insert(0, dialog);
    });
    Navigator.pop(context);
  }

  void deleteDialog(dynamic context, ListItem dialog) {
    setState(() {
      for (var i = 0; i < dialogs.length; i++) {
        if (dialogs[i].id == dialog.id) {
          dialogs.removeAt(i);
        }
      }
    });
    Navigator.pop(context);
  }

  int editingDialog(ListItem dialog) {
    for (var i = 0; i < dialogs.length; i++) {
      if (dialogs[i].id == dialog.id) {
        return i;
      }
    }
    return 0;
  }

  int editingIcon(ListItem dialog) {
    for (var i = 0; i < iconsList.length; i++) {
      if (iconsList[i] == dialog.icon) {
        return i;
      }
    }
    return 0;
  }

  Widget bottomBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: isLightTheme ? Colors.white : Colors.black,
      onTap: _onItemTapped,
      selectedItemColor: Colors.orange[300],
      unselectedItemColor: isLightTheme ? Colors.deepPurple[300] : Colors.white,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        navigationBarItem('Home', Icons.book),
        navigationBarItem('Daily', Icons.assignment),
        navigationBarItem('Timeline', Icons.timeline),
        navigationBarItem('Explore', Icons.explore),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem navigationBarItem(
      String bottomNavigationBarLabel, IconData bottomNavigationBarIcon) {
    return BottomNavigationBarItem(
      icon: Icon(
        bottomNavigationBarIcon,
        size: 30,
      ),
      label: bottomNavigationBarLabel,
    );
  }
}
