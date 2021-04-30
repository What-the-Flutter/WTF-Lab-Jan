import 'package:flutter/material.dart';

import '../../config/custom_theme.dart';
import '../../constants/constants.dart';
import '../../constants/themes.dart';
import '../../models/note.dart';
import '../event/event_screen.dart';
import '../note/add_note_screen.dart';
import 'components/questionnaire_bot.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  MyThemeKeys themeKey;
  bool themeChanged = false;

  void addIcons() {
    setState(() {
      for (var i = 0; i < iconsList.length; i++) {
        icons.add(ListItemIcon<IconData>(iconsList[i]));
        icons[i].isSelected = false;
      }
      icons[0].isSelected = true;
    });
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: drawer(context),
      appBar: appBar(),
      body: body(size),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addIcons();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  SingleChildScrollView body(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          QuestionnaireBot(),
          notesList(size),
        ],
      ),
    );
  }

  SizedBox notesList(Size size) {
    return SizedBox(
          height: size.height,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16.0),
                padding: EdgeInsets.only(
                  top: size.height * 0.12,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    Note note;
                    note = notes[index];
                    return Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventScreen(note: note, title: note.title),
                            ),
                          );
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (bc) {
                              return Wrap(
                                children: <Widget>[
                                  ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      onTap: () async {
                                        // for (var i = 0; i < icons.length; i++) {
                                        //   icons[i].isSelected = false;
                                        // }
                                        // icons[editingIcon(dialog)].isSelected = true;
                                        // await Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => AddDialogPage(
                                        //       controller: dialog.name,
                                        //       operation: 'edit',
                                        //       editingDialog: editingDialog(dialog),
                                        //       editingIcon: editingIcon(dialog),
                                        //     ),
                                        //   ),
                                        // );
                                        // setState(() {});
                                        // Navigator.of(context).pop();
                                      }),
                                  ListTile(
                                      leading: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text(
                                        'Delete',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          for (var i = 0; i < notes.length; i++) {
                                            if (notes[i].id == note.id) {
                                              notes.removeAt(i);
                                            }
                                          }
                                          Navigator.pop(context);
                                        });
                                      }),
                                  ListTile(
                                    leading: Icon(
                                      Icons.info,
                                      color: Theme.of(context).accentColor,
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
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      );
                                      var alert = AlertDialog(
                                        title: Text(note.title),
                                        content: Text(
                                            'Creation date:\n${note.subtitle}'),
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
                                      color: Theme.of(context).accentColor,
                                    ),
                                    title: Text(
                                      'Pin/Unpin',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onTap: () {
                                      // if (dialog.isPinned == false) {
                                      //   pinDialog(context, dialog);
                                      // } else {
                                      //   unpinDialog(context, dialog);
                                      // }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ListTile(
                            tileColor: Theme.of(context).backgroundColor,
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 30.0,
                              child: Icon(
                                note.isPinned ? Icons.push_pin : note.icon,
                                size: 35.0,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              note.title,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text('Item 3'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Home'),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.invert_colors,
          ),
          onPressed: () {
            themeChanged = !themeChanged;
            if (themeChanged == true) {
              themeKey = MyThemeKeys.dark;
            } else {
              themeKey = MyThemeKeys.light;
            }
            _changeTheme(context, themeKey);
          },
        ),
      ],
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: Theme.of(context).backgroundColor,
      selectedItemColor: Theme.of(context).buttonColor,
      unselectedItemColor: Colors.blueGrey,
      elevation: 1.0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline_outlined),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
      ],
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}
