import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../create_new_page.dart';
import '../../../logic/home_screen_cubit.dart';
import '../../../repository/property_page.dart';
import '../../../screen_message.dart';
import '../../theme/theme_model.dart';

class EventPage extends StatefulWidget {
  final int _index;

  EventPage(this._index);

  @override
  _EventPageState createState() => _EventPageState(_index);
}

class _EventPageState extends State<EventPage> {
  final int _index;

  _EventPageState(this._index);

  @override
  Widget build(BuildContext context) {
    var page = BlocProvider.of<HomeScreenCubit>(context).eventPages[_index];
    return InkWell(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          ScreenMessage.routeName,
          arguments: page,
        );
        context.read<HomeScreenCubit>().editMessages(_index, result);
      },
      onLongPress: () => _showMenuAction(page),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          ListTile(
            title: Text(
              page.title,
            ),
            subtitle: Text('No Events. Click to create one.'),
            horizontalTitleGap: 5.0,
            contentPadding: EdgeInsets.all(5.0),
            leading: _createIcon(page.icon),
          ),
          if (context.read<HomeScreenCubit>().state.isPin) Icon(Icons.push_pin),
        ],
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
    final cubit = context.read<HomeScreenCubit>();
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
              onPressed: () {
                //ChatPages.pages.sort()
              },
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
                    arguments: _index,
                  );
                  cubit.editPage(_index, result);
                }),
            createItem(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: 'Delete Page',
              onPressed: () {
                Navigator.pop(context);
                context.read<HomeScreenCubit>().removePage(_index);
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
                subtitle: Text(page.creationTime.toString()),
              ),
              ListTile(
                title: Text('Latest Event'),
                subtitle: Text(page.lastModifiedTime.toString()),
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
