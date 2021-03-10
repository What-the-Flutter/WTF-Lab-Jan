import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/custom_icon/my_flutter_app_icons.dart';
import '../data/model/model_page.dart';
import '../data/theme/theme.dart';
import '../data/theme/theme_model.dart';
import '../messages_screen/screen_message.dart';
import '../screen_creating_page/create_new_page.dart';
import 'home_screen_cubit.dart';

class HomeWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Home'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: () {
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
            },
          ),
        ],
        leading: Icon(Icons.menu),
      ),
      body: ChatPages(),
      floatingActionButton: ButtonAddChat(),
      bottomNavigationBar: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) => BottomNavigationBar(
          currentIndex: state.currentIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Daily',
              icon: Icon(
                Icons.event_note_sharp,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Timeline',
              icon: Icon(
                Icons.timeline,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Explore',
              icon: Icon(
                Icons.explore,
              ),
            )
          ],
          onTap: (index) => context.read<HomeScreenCubit>().changeScreen(index),
        ),
      ),
    );
  }
}

class ChatPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) => ListView.separated(
        itemCount: state.list.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _buildBot(context);
          return EventPage(i - 1);
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }

  Widget _buildBot(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            MyFlutterApp.smart_toy_24px,
            size: 30,
          ),
          Text(
            'Questionnaire Bot',
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Provider.of<ThemeModel>(context).currentTheme == darkTheme
            ? Colors.black
            : Colors.green[50],
      ),
      margin: EdgeInsetsDirectional.only(start: 30.0, top: 5.0, end: 30.0),
      width: 200,
      height: 50,
    );
  }
}

class ButtonAddChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 10.0,
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
      onPressed: () async {
        final result = await Navigator.pushNamed(
          context,
          CreateNewPage.routName,
          arguments: ModelPage(
            title: '',
            icon: Icons.title,
          ),
        );
        if (result != null) context.read<HomeScreenCubit>().addPage(result);
      },
    );
  }
}

class EventPage extends StatelessWidget {
  final int _index;

  EventPage(this._index);

  @override
  Widget build(BuildContext context) {
    final state = context.read<HomeScreenCubit>().state;
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
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          ListTile(
            title: Text(state.list[_index].title),
            subtitle: Text('No Events. Click to create one.'),
            horizontalTitleGap: 5.0,
            contentPadding: EdgeInsets.all(5.0),
            leading: Container(
              width: 75,
              height: 75,
              child: Icon(
                state.list[_index].icon,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Provider.of<ThemeModel>(context).currentTheme.cardColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          state.list[_index].isPin
              ? Icon(
                  Icons.push_pin,
                  color: Colors.blue,
                )
              : Container()
        ],
      ),
    );
  }

  void _showMenuAction(BuildContext context) {
    final cubit = context.read<HomeScreenCubit>();
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
                  if (result != null) cubit.editPage(_index, result);
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

  void _showDialogInfo(HomeScreenCubit cubit, BuildContext context) {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(cubit.state.list[_index].title),
                leading: Container(
                  width: 75,
                  height: 75,
                  child: Icon(
                    cubit.state.list[_index].icon,
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
                subtitle: Text(
                  cubit.state.list[_index].creationTime.toString(),
                ),
              ),
              ListTile(
                title: Text('Latest Event'),
                subtitle: Text(
                  cubit.state.list[_index].lastModifiedTime.toString(),
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
}
