import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_pages.dart';
import 'create_new_page.dart';
import 'list_item.dart';
import 'screen_message.dart';
import 'theme_model.dart';

class EventPage extends StatefulWidget {
  final int _index;

  final _removeItem;

  EventPage(this._index, this._removeItem);

  @override
  _EventPageState createState() => _EventPageState(_index, _removeItem);
}

class _EventPageState extends State<EventPage> {
  final int _index;
  final _removeItem;

  _EventPageState(this._index, this._removeItem);

  @override
  Widget build(BuildContext context) {
    var page = ChatPages.pages[_index];
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ScreenMessage.routeName,
          arguments: page,
        );
      },
      onLongPress: () => _showMenuAction(page),
      child: ListTile(
        title: Text(
          page.title,
        ),
        subtitle: Text('No Events. Click to create one.'),
        horizontalTitleGap: 5.0,
        contentPadding: EdgeInsets.all(5.0),
        leading: _createIcon(page.icon),
      ),
    );
  }

  Widget _createIcon(IconData iconData) {
    return Container(
      width: 75,
      height: 75,
      child: Icon(
        iconData,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Provider.of<ThemeModel>(context).currentTheme.cardColor,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showMenuAction(PropertyPage page) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            createItem(
              icon: Icon(
                Icons.info,
                color: Colors.teal,
              ),
              title: 'info',
              onPressed: () => _showDialogInfo(page),
            ),
            createItem(
              icon: Icon(
                Icons.attach_file,
                color: Colors.teal,
              ),
              title: 'Pin/Unpin Page',
              onPressed: () {},
            ),
            createItem(
              icon: Icon(
                Icons.archive,
                color: Colors.orange,
              ),
              title: 'Archive Page',
              onPressed: () {},
            ),
            createItem(
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: 'Edit page',
              onPressed: () async {
                Navigator.pop(context);
                final result = await Navigator.pushNamed(
                  context,
                  CreateNewPage.routName,
                  arguments: page,
                );
                setState(() {
                  ChatPages.pages.removeAt(_index);
                  ChatPages.pages.insert(_index, result);
                });
              },
            ),
            createItem(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: 'Delete Page',
              onPressed: () {
                Navigator.pop(context);
                _removeItem(_index);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogInfo(PropertyPage page) {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(page.title),
                leading: Container(
                  width: 75,
                  height: 75,
                  child: Icon(
                    page.icon,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              ListTile(
                title: Text('Created'),
                subtitle: Text('data'),
              ),
              ListTile(
                title: Text('Latest Event'),
                subtitle: Text('Data'),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Center(
                child: Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget createItem({
    Icon icon,
    String title,
    Function onPressed,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      ),
      onTap: onPressed,
    );
  }
}

class PropertyPage {
  final IconData _icon;
  final String _title;
  final List<ListItem<String>> _messages;

  PropertyPage(this._icon, this._title, this._messages);

  String get title => _title;

  List<ListItem<String>> get messages => _messages;

  IconData get icon => _icon;
}
