import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/custom_icon/my_flutter_app_icons.dart';
import '../data/model/model_page.dart';
import '../main.dart';
import '../messages_screen/screen_message.dart';
import '../messages_screen/screen_message_cubit.dart';
import '../screen_creating_page/create_new_page.dart';
import '../screen_creating_page/screen_creating_page_cubit.dart';
import '../search_messages_screen/search_message_screen_cubit.dart';
import '../settings_screen/general_options_cubit.dart';
import '../settings_screen/settings_screen.dart';
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
              context.read<GeneralOptionsCubit>().toggleTheme();
              saveTheme(
                  context.read<GeneralOptionsCubit>().state.themeType.index);
            },
          ),
        ],
      ),
      drawer: _drawer(context),
      body: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) => (state is HomeScreenShow)
            ? ChatPages()
            : Center(
                child: Text('Await'),
              ),
      ),
      floatingActionButton: ButtonAddChat(),
      bottomNavigationBar: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: _bottomNavigationBar,
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Help spread the word'),
            onTap: () {
              //TODO
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              // TODO
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              //TODO
            },
          ),
          ListTile(
            leading: Icon(Icons.stacked_line_chart),
            title: Text('Statistics'),
            onTap: () {
              //TODO
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                SettingsScreen.routeName,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {},
          )
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context, HomeScreenState state) {
    return BottomNavigationBar(
      currentIndex: state.currentIndex,
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
        color: context.read<GeneralOptionsCubit>().state.currentTheme.bot,
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
      ),
      onPressed: () async {
        context.read<ScreenCreatingPageCubit>().setting('', 0);
        await Navigator.pushNamed(
          context,
          CreateNewPage.routName,
        );
        final state = context.read<ScreenCreatingPageCubit>().state;
        if (state.iconButton != Icons.close) {
          context.read<HomeScreenCubit>().addPage(
                ModelPage(
                  iconIndex: state.selectionIconIndex,
                  title:
                      context.read<ScreenCreatingPageCubit>().controller.text,
                ),
              );
        }
        context.read<ScreenCreatingPageCubit>().resetIcon();
      },
    );
  }
}

class EventPage extends StatelessWidget {
  final int _index;

  EventPage(this._index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context.read<ScreenMessageCubit>().downloadData(
              context.read<HomeScreenCubit>().state.list[_index],
            );
        context
            .read<SearchMessageScreenCubit>()
            .setting(page: context.read<HomeScreenCubit>().state.list[_index]);
        await Navigator.pushNamed(
          context,
          ScreenMessage.routeName,
        );
        //context.read<HomeScreenCubit>().gettingOutFreeze();
      },
      onLongPress: () => _showMenuAction(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          ListTile(
            title:
                Text(context.read<HomeScreenCubit>().state.list[_index].title),
            subtitle: Text('No Events. Click to create one.'),
            horizontalTitleGap: 5.0,
            contentPadding: EdgeInsets.all(5.0),
            leading: Container(
              width: 75,
              height: 75,
              child: Icon(
                context.read<ScreenCreatingPageCubit>().getIcon(context
                    .read<HomeScreenCubit>()
                    .state
                    .list[_index]
                    .iconIndex),
              ),
              decoration: BoxDecoration(
                color: context
                    .read<GeneralOptionsCubit>()
                    .state
                    .currentTheme
                    .backgroundCategory,
                shape: BoxShape.circle,
              ),
            ),
          ),
          context.read<HomeScreenCubit>().state.list[_index].isPin
              ? Icon(
                  Icons.push_pin,
                )
              : Container()
        ],
      ),
    );
  }

  void _showMenuAction(BuildContext context) {
    final homeCubit = context.read<HomeScreenCubit>();
    final screenCreatingCubit = context.read<ScreenCreatingPageCubit>();
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Column(
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
            onTap: () => _showDialogInfo(homeCubit, context),
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
              homeCubit.pinPage(_index);
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
              screenCreatingCubit.setting(
                homeCubit.state.list[_index].title,
                homeCubit.state.list[_index].iconIndex,
              );
              await Navigator.pushNamed(
                context,
                CreateNewPage.routName,
              );
              if (screenCreatingCubit.state.iconButton != Icons.close) {
                homeCubit.editPage(
                  homeCubit.state.list[_index].copyWith(
                    iconIndex: screenCreatingCubit.state.selectionIconIndex,
                    title: screenCreatingCubit.controller.text,
                  ),
                );
              }
              screenCreatingCubit.resetIcon();
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
              context.read<HomeScreenCubit>().removePage(_index);
            },
          ),
        ],
      ),
    );
  }

  void _showDialogInfo(HomeScreenCubit cubit, BuildContext context) {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(cubit.state.list[_index].title),
              leading: Container(
                width: 75,
                height: 75,
                child: Icon(
                  context
                      .read<ScreenCreatingPageCubit>()
                      .getIcon(cubit.state.list[_index].iconIndex),
                ),
                decoration: BoxDecoration(
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
      ),
    );
  }
}
