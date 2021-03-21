import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/property_page.dart';
import '../../theme/theme_model.dart';
import '../creating_new_page/creating_new_page.dart';
import '../creating_new_page/creating_new_page_cubit.dart';
import '../messages/screen_messages.dart';
import '../messages/screen_messages_cubit.dart';
import '../search/searching_messages_cubit.dart';
import '../settings/settings_page.dart';
import 'home_screen_cubit.dart';
import 'widgets/bottom_panel_tabs.dart';

class StartWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<HomePageCubit>().loadData();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Home',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Provider.of<ThemeModel>(context, listen: false).changeTheme();
              },
              icon: Icon(Icons.invert_colors),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomePageCubit, HomeScreenState>(
        builder: (context, state) {
          if (state is HomeScreenStateAwait) {
            return Center(
              child: Text('Please,wait few seconds'),
            );
          } else {
            return DialogsPages();
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  DateFormat.yMMMMd('en_US').format(DateTime.now()),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              decoration: BoxDecoration(
                color:
                    Provider.of<ThemeModel>(context).currentTheme.accentColor,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 30,
              ),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  SettingsPage.routeName,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonAddChat(),
      bottomNavigationBar: BottomPanelTabs(),
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
        context.read<CreatingNewPageCubit>().setting('', 0);
        await Navigator.pushNamed(
          context,
          CreateNewPage.routeName,
        );
        final state = context.read<CreatingNewPageCubit>().state;
        if (state.iconButton != Icons.close) {
          context.read<HomePageCubit>().addPage(PropertyPage(
                title: context.read<CreatingNewPageCubit>().controller.text,
                iconIndex: state.selectionIconIndex,
              ));
        }
        context.read<CreatingNewPageCubit>().resetIcon();
      },
    );
  }
}

class DialogsPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          color: Provider.of<ThemeModel>(context).currentTheme.primaryColor,
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white,
          ),
          child: BlocBuilder<HomePageCubit, HomeScreenState>(
            builder: (context, state) => ListView.builder(
              itemCount: state.list.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return _buildBot(context);
                }
                return DialogPage(i - 1);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBot(BuildContext context) {
    return Row(
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
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DialogPage extends StatelessWidget {
  final int _index;

  DialogPage(this._index);

  @override
  Widget build(BuildContext context) {
    final state = context.read<HomePageCubit>().state;
    return InkWell(
      onTap: () async {
        print(_index);
        context.read<ScreenMessagesCubit>().downloadData(
              state.list[_index],
              InputAppBar(
                title: state.list[_index].title,
              ),
            );
        context.read<SearchMessageCubit>().setting(page: state.list[_index]);
        await Navigator.pushNamed(
          context,
          ScreenMessages.routeName,
        );
        context.read<HomePageCubit>().gettingOutFreeze();
      },
      onLongPress: () => _showMenuAction(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            ListTile(
                title: Text(
                  state.list[_index].title,
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text('No Events. Click to create one.'),
                contentPadding: EdgeInsets.all(5.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[50],
                  radius: 30,
                  child: Icon(
                    context
                        .read<CreatingNewPageCubit>()
                        .getIcon(state.list[_index].iconIndex),
                    size: 35,
                    color:
                        Provider.of<ThemeModel>(context).currentTheme.cardColor,
                  ),
                )),
            if (state.list[_index].isPin)
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
      ),
    );
  }

  void _showMenuAction(BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final createNewPageCubit = context.read<CreatingNewPageCubit>();
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
                  createNewPageCubit.setting(
                    cubit.state.list[_index].title,
                    cubit.state.list[_index].iconIndex,
                  );
                  await Navigator.pushNamed(
                    context,
                    CreateNewPage.routeName,
                  );
                  if (createNewPageCubit.state.iconButton != Icons.close) {
                    cubit.editPage(
                      cubit.state.list[_index].copyWith(
                        iconIndex: createNewPageCubit.state.selectionIconIndex,
                        title: createNewPageCubit.controller.text,
                      ),
                    );
                  }
                  createNewPageCubit.resetIcon();
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
                  context.read<HomePageCubit>().removePage(_index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialogInfo(HomePageCubit cubit, BuildContext context) {
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
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[50],
                  radius: 30,
                  child: Icon(
                    context
                        .read<CreatingNewPageCubit>()
                        .getIcon(cubit.state.list[_index].iconIndex),
                    size: 35,
                    color: Colors.orange,
                  ),
                ),
              ),
              ListTile(
                title: Text('Created'),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd – hh:mm')
                      .format(cubit.state.list[_index].creationTime),
                ),
              ),
              ListTile(
                title: Text('Last modification'),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd – hh:mm')
                      .format(cubit.state.list[_index].lastModifiedTime),
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
