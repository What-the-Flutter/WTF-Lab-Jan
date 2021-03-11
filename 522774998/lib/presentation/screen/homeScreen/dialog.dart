import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../logic/dialog_page_cubit.dart';
import '../../../../logic/home_screen_cubit.dart';
import '../../theme/theme_model.dart';
import '../create_new_page.dart';
import '../screen_message.dart';

class DialogPage extends StatelessWidget {
  final int _index;

  DialogPage(this._index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ScreenMessage.routeName,
          arguments:
              context.read<HomePageCubit>().repository.dialogPages[_index],
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
                  horizontalTitleGap: 5.0,
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
        return Column(
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
                  Navigator.pop(context);
                  final result = await Navigator.pushNamed(
                    context,
                    CreateNewPage.routName,
                    arguments: context
                        .read<HomePageCubit>()
                        .repository
                        .dialogPages[_index],
                  );
                  cubit.editPage(_index, result);
                }),
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
                context.read<HomePageCubit>().removePage(_index);
              },
            ),
          ],
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
                subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(
                    BlocProvider.of<HomePageCubit>(context)
                        .repository
                        .dialogPages[_index]
                        .creationTime)),
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
