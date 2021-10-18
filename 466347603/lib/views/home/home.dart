import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/page_info.dart';
import '../../theme/theme_cubit.dart';
import '../../utils/data.dart';
import 'home_cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: _drawer(context),
      body: _pageList(context),
      floatingActionButton: _floatingActionButton(context),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Center(
        child: Text('Home'),
      ),
      actions: <Widget>[
        IconButton(
          icon: context.read<ThemeCubit>().isDarkMode
              ? const Icon(Icons.dark_mode)
              : const Icon(Icons.dark_mode_outlined),
          onPressed: context.read<ThemeCubit>().changeTheme,
        ),
      ],
    );
  }

  Widget _drawer(BuildContext context) {
    final now = DateTime.now();
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            alignment: Alignment.bottomLeft,
            height: 200,
            padding: const EdgeInsets.all(25),
            child: Text(
              '${months[now.month - 1]} ${now.day}, ${now.year}',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          _drawerList(context),
        ],
      ),
    );
  }

  Widget _drawerList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/settings-screen',
              );
            },
            child: _drawerListElement(
              name: 'Settings',
              icon: Icons.settings,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerListElement({required IconData icon, required String name}) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 22),
          Text(name, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _pageList(BuildContext context) {
    context.read<HomeCubit>().init();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: state.pages.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                var lastEvent = await Navigator.pushNamed(
                  context,
                  '/events-screen',
                  arguments: state.pages[index],
                ) as List;
                context.read<HomeCubit>().updateLastEvent(lastEvent);
              },
              onLongPress: () => _showPageOptions(context, index),
              child: _pageListElement(context, state.pages[index]),
            );
          },
        );
      },
    );
  }

  Widget _pageListElement(BuildContext context, PageInfo page) {
    final state = context.read<HomeCubit>().state;
    final lastMessage = state.lastMessagePageId == page.id
        ? state.lastMessageEvent
        : page.lastMessage;
    return ListTile(
      leading: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            child: page.icon,
            radius: 28,
            backgroundColor: Theme.of(context).cardColor,
          ),
          if (page.isPinned)
            const Icon(
              Icons.push_pin,
              size: 15,
              color: Colors.black54,
            ),
        ],
      ),
      title: Text(
        page.title,
        style: const TextStyle(fontSize: 25),
      ),
      subtitle: Text(lastMessage),
    );
  }

  Future<dynamic> _showPageOptions(BuildContext context, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              onTap: () => _showPageInfo(context, index),
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Info'),
            ),
            ListTile(
              onTap: () => _pinPage(context, index),
              leading: Icon(
                Icons.attach_file,
                color: Colors.green[500],
              ),
              title: const Text('Pin/Unpin page'),
            ),
            ListTile(
              onTap: () => _updatePage(context, index),
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: const Text('Edit Page'),
            ),
            ListTile(
              onTap: () => _deletePage(context, index),
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Page'),
            ),
          ],
        );
      },
    );
  }

  void _showPageInfo(BuildContext context, int index) {
    final pages = context.read<HomeCubit>().state.pages;
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: pages[index].icon,
                  radius: 32,
                  backgroundColor: Theme.of(context).cardColor,
                ),
                title: Text(
                  pages[index].title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Created at '),
                    Text(pages[index].createDate!),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: ElevatedButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _pinPage(BuildContext context, int index) async {
    context.read<HomeCubit>().pinPage(index);
    Navigator.of(context).pop();
  }

  void _updatePage(BuildContext context, int index) async {
    final homeCubit = context.read<HomeCubit>();
    final pages = homeCubit.state.pages;
    final page = await Navigator.of(context).popAndPushNamed(
      '/create-screen',
      arguments: pages[index],
    );
    homeCubit.updatePage(index, page as PageInfo, pages[index].id!);
  }

  void _deletePage(BuildContext context, int index) {
    Navigator.of(context).pop();
    context.read<HomeCubit>().deletePage(index);
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addPage(context),
      backgroundColor: Colors.yellow[600],
      child: const Icon(
        Icons.add,
        color: Colors.black,
      ),
    );
  }

  void _addPage(BuildContext context) async {
    final page = await Navigator.of(context).pushNamed('/create-screen');
    if (page is PageInfo) {
      context.read<HomeCubit>().addPage(page);
    }
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.selectedContent,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_added),
              label: 'Daily',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
          ],
          onTap: (index) => context.read<HomeCubit>().changeNavBarItem(index),
        );
      },
    );
  }
}
