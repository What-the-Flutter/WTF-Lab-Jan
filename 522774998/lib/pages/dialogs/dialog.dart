import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../repository/messages_repository.dart';
import '../../theme/theme_model.dart';
import '../creating_new_page/creating_new_page.dart';
import '../home/home_screen_cubit.dart';
import '../messages/screen_messages.dart';
import 'dialog_page_cubit.dart';

class DialogPage extends StatelessWidget {
  final int _index;
  final DBHelper _dbHelper = DBHelper();

  DialogPage(this._index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(_index);
        var messagesRepository = MessagesRepository();
        await messagesRepository.setAllMessages(_index);
        Navigator.pushNamed(
          context,
          ScreenMessages.routeName,
          arguments: ScreenMessages(
            context.read<HomePageCubit>().repository.dialogPages[_index],
            messagesRepository,
          ),
        );
      },
      onLongPress: () => _showMenuAction(context),
      child: BlocBuilder<DialogPageCubit, DialogPageState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                ListTile(
                  title: Text(
                    state.title,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text('No Events. Click to create one.'),
                  contentPadding: EdgeInsets.all(5.0),
                  leading: _createIcon(state.icon, context),
                ),
                if (state.isPin)
                  Container(
                    padding: EdgeInsets.only(bottom: 5, left: 5),
                    child: Icon(
                      Icons.push_pin,
                      color: Provider.of<ThemeModel>(context)
                          .currentTheme
                          .primaryColor,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _createIcon(IconData iconData, BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.orange[50],
      radius: 30,
      child: Icon(
        iconData,
        size: 35,
        color: Provider.of<ThemeModel>(context).currentTheme.cardColor,
      ),
    );
  }

  void _showMenuAction(BuildContext context) {
    final cubit = context.read<DialogPageCubit>();
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.info,
                  color:
                      Provider.of<ThemeModel>(context).currentTheme.accentColor,
                ),
                title: Text(
                  'info',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                onTap: () => _showDialogInfo(cubit, context),
              ),
              ListTile(
                leading: Icon(
                  Icons.attach_file,
                  color:
                      Provider.of<ThemeModel>(context).currentTheme.accentColor,
                ),
                title: Text(
                  'Pin/Unpin Page',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pinPage(_index);
                  _dbHelper.updatePage(BlocProvider.of<HomePageCubit>(context)
                      .repository
                      .dialogPages[_index]);
                  context.read<HomePageCubit>().updateList();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color:
                      Provider.of<ThemeModel>(context).currentTheme.accentColor,
                ),
                title: Text(
                  'Edit page',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    CreateNewPage.routName,
                    arguments: context
                        .read<HomePageCubit>()
                        .repository
                        .dialogPages[_index],
                  );
                  Navigator.pop(context);
                  cubit.editPage(_index, result);
                  _dbHelper.updatePage(BlocProvider.of<HomePageCubit>(context)
                      .repository
                      .dialogPages[_index]);
                  context.read<HomePageCubit>().updateList();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete Page',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _dbHelper.deletePage(BlocProvider.of<HomePageCubit>(context)
                      .repository
                      .dialogPages[_index]);
                  context.read<HomePageCubit>().removePage(_index);
                  context.read<HomePageCubit>().updateList();
                  //_updateSuggestionList();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialogInfo(DialogPageCubit cubit, BuildContext context) {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(cubit.state.title),
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[50],
                  radius: 30,
                  child: Icon(
                    cubit.state.icon,
                    size: 35,
                    color: Colors.orange,
                  ),
                ),
              ),
              ListTile(
                title: Text('Created'),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd – kk:mm').format(
                      BlocProvider.of<HomePageCubit>(context)
                          .repository
                          .dialogPages[_index]
                          .creationTime),
                ),
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

  Widget createItem({Icon icon, String title, Function onPressed}) {
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
