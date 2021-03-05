import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../logic/event_page_cubit.dart';
import '../../../logic/home_screen_cubit.dart';
import '../../theme/theme_model.dart';
import '../create_new_page.dart';
import '../screen_message.dart';

class EventPage extends StatelessWidget {
  final int _index;

  EventPage(this._index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ScreenMessage.routeName,
          arguments:
              context.read<HomeScreenCubit>().repository.eventPages[_index],
        );
      },
      onLongPress: () => _showMenuAction(context),
      child: BlocBuilder<EventPageCubit, EventPageState>(
        builder: (context, state) {
          print('buildPage ${state.title} $_index');
          return Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              ListTile(
                title: Text(
                  state.title,
                ),
                subtitle: Text('No Events. Click to create one.'),
                horizontalTitleGap: 5.0,
                contentPadding: EdgeInsets.all(5.0),
                leading: _createIcon(state.icon, context),
              ),
              if (state.isPin)
                Icon(
                  Icons.push_pin,
                  color: Colors.blue,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _createIcon(IconData iconData, BuildContext context) {
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

  void _showMenuAction(BuildContext context) {
    final cubit = context.read<EventPageCubit>();
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
                color: Colors.teal,
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
                color: Colors.teal,
              ),
              title: Text(
                'Pin/Unpin Page',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.pop(context);
                cubit.pinPage(_index);
                context.read<HomeScreenCubit>().updateList();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.archive,
                color: Colors.orange,
              ),
              title: Text(
                'Archive Page',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              onTap: () {},
            ),
            ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.blue,
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
                        .read<HomeScreenCubit>()
                        .repository
                        .eventPages[_index],
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
                context.read<HomeScreenCubit>().removePage(_index);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogInfo(EventPageCubit cubit, BuildContext context) {
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
                leading: Container(
                  width: 75,
                  height: 75,
                  child: Icon(
                    cubit.state.icon,
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
                subtitle: Text(BlocProvider.of<HomeScreenCubit>(context)
                    .repository
                    .eventPages[_index]
                    .creationTime
                    .toString()),
              ),
              ListTile(
                title: Text('Latest Event'),
                subtitle: Text(cubit.state.time.toString()),
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
