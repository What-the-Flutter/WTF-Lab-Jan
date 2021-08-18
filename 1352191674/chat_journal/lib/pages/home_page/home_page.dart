import 'package:chat_journal/models/page_mode.dart';
import 'package:chat_journal/pages/create_page/create_page.dart';
import 'package:chat_journal/pages/events_page/events_page.dart';
import 'package:chat_journal/services/switch_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



import 'home_bloc.dart';
import 'home_extras.dart';

class HomePage extends StatelessWidget {
  final _bloc = HomeBloc();

  AppBar _appbar(HomeState state, context) {
    return AppBar(
      centerTitle: true,
      title: const Text('Home', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(
            Icons.opacity,
          ),
          onPressed: () => _bloc.add(ThemeChangeEvent(state.isLigth!)),
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 10,
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
                DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: Text('Help spread the world'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text('Search'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.multiline_chart),
            title: Text('Statistics'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _homePagesList(BuildContext context, HomeState state) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      separatorBuilder: (context, index) => Divider(),
      itemCount: state.pages.length,
      itemBuilder: (context, index) {
        return ListTile(
          onLongPress: () => _showPopupMenu(index, context, state),
          contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => state.pages[index].eventPage,
            ),
          ),
          leading: Icon(state.pages[index].icon),
          title: Text(
            state.pages[index].name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _infoPage(String title, BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  void _showInfo(int index, BuildContext context, HomeState state) {
    showDialog(
      context: context,
      builder: (context) {
        return _infoPage(state.pages[index].name, context);
      },
    );
  }

  void _showPopupMenu(int index, BuildContext context, HomeState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info, color: Colors.teal),
              title: Text('Info'),
              onTap: () {
                _showInfo(index, context, state);
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_file_outlined, color: Colors.green),
              title: Text('Pin/Unpin Page'),
              onTap: () {
                _showInfo(index, context, state);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Page'),
              onTap: () async {
                List<Object> editPageInfo = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePage(
                            isEdit: true,
                            pageTitle: state.pages[index].name,
                            pageIcon: state.pages[index].icon)));
                var iconIndex = editPageInfo[1] as int;
                var editPageName = editPageInfo[0].toString();
                var eventPage = EventPage(title: editPageName);
                var editPage = AppPage(editPageName, iconsList[iconIndex],eventPage);
                _bloc.add(EditPageEvent(index, editPage, state.pages));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text('Delete Page'),
              onTap: () async {
                _bloc.add(DeletePageEvent(index, state.pages));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _bloc,
      listenWhen: (previous, current) {
        return previous.isLigth != null || current.isLigth != null;
      },
      listener: (context, state) async {
        print(state.isLigth.toString());
        if (state.isLigth == true) {
          themeChanger.setTheme(ThemeMode.dark);
        } else {
          themeChanger.setTheme(ThemeMode.light);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar(state, context),
          drawer: _drawer(),
          body: _homePagesList(context, state),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                List<Object> newPageInfo = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatePage()));
                var iconIndex = newPageInfo[1] as int;
                var newPageName = newPageInfo[0].toString();
                var eventPage = EventPage(title: newPageName);
                var page = AppPage(newPageName, iconsList[iconIndex],eventPage);
                _bloc.add(AddPageEvent(page, state.pages));
              },
              child: const Icon(Icons.add)),
        );
      },
    );
  }

}
