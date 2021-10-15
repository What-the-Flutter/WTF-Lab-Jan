import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wtf/pages/authorization/authorization_cubit.dart';

import '../../util/domain.dart';
import '../../util/shared_preferences/shared_preferences_cubit.dart';
import '../chat_page/chat_page.dart';
import '../settings/settings_page/settings_page.dart';
import 'chose_of_action/chose_of_action.dart';
import 'home_page_cubit.dart';

class ChatJournalHomePage extends StatefulWidget {
  ChatJournalHomePage();

  @override
  _ChatJournalHomePageState createState() => _ChatJournalHomePageState();
}

class _ChatJournalHomePageState extends State<ChatJournalHomePage> {
  late final _appBars;
  int _selectedIndex = 0;

  @override
  void initState() {
    BlocProvider.of<HomePageCubit>(context).init();
    _appBars = [
      _appBarFromHomePage(),
      _appBarFromDailyPage(),
      _appBarFromTimelinePage(),
      _appBarFromExplorePage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[100],
          appBar: _appBars[_selectedIndex],
          body: _bodyOfHomePageChat(state),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              BlocProvider.of<HomePageCubit>(context).addCategory(
                context,
              );
              BlocProvider.of<HomePageCubit>(context).updateList(
                state.categories,
              );
            },
            child: const Icon(
              Icons.add_sharp,
              color: Colors.yellow,
            ),
          ),
          bottomNavigationBar: _chatBottomNavigationBar(),
          drawer: _navigationDrawerWidget(),
        );
      },
    );
  }

  AppBar _appBarFromHomePage() {
    return AppBar(
      title: const Center(
        child: Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.read<SharedPreferencesCubit>().changeTheme(),
          icon: const Icon(
            Icons.invert_colors,
          ),
        ),
      ],
      leading: IconButton(
        onPressed: _navigationDrawerWidget,
        icon: const Icon(
          Icons.list,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  AppBar _appBarFromDailyPage() {
    return AppBar(
      title: const Center(
        child: Text(
          'Daily',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.list,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.flutter_dash_rounded,
          ),
        ),
      ],
      backgroundColor: Colors.black,
    );
  }

  AppBar _appBarFromTimelinePage() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.list,
        ),
      ),
      title: const Center(
        child: Text(
          'Timeline',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bookmark_border_outlined,
          ),
        ),
      ],
    );
  }

  AppBar _appBarFromExplorePage() {
    return AppBar(
      title: const Center(
        child: Text(
          'Explore',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: _navigationDrawerWidget,
        icon: const Icon(
          Icons.list,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _bodyOfHomePageChat(HomePageState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: state.categories.length + 1,
            itemBuilder: (
              context,
              index,
            ) {
              if (index == 0) {
                return _firstConditionPadding();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  5,
                  2,
                  5,
                  1,
                ),
                child: Card(
                  child: ListTile(
                    title: Text(
                      state.categories[index - 1].title,
                    ),
                    subtitle: Text(
                      state.categories[index - 1].subTitleMessage.isEmpty
                          ? 'No events. Click to create one.'
                          : state.categories[index - 1].subTitleMessage,
                    ),
                    leading: CircleAvatar(
                      child: Icon(
                        initialIcons[state.categories[index - 1].iconIndex],
                      ),
                      backgroundColor: Colors.black,
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => BlocProvider.value(
                          child: ChoseOfAction(
                            state.categories,
                            index - 1,
                          ),
                          value: BlocProvider.of<HomePageCubit>(
                            context,
                          ),
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            category: state.categories[index - 1],
                            categories: state.categories,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Padding _firstConditionPadding() {
    return Padding(
      padding: const EdgeInsets.all(
        10.0,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.fromLTRB(1, 1, 1, 1),
          ),
          overlayColor: MaterialStateProperty.all(
            Colors.blueGrey[100],
          ),
          shadowColor: MaterialStateProperty.all(
            Colors.black,
          ),
          elevation: MaterialStateProperty.all(
            40,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                100,
              ),
            ),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'image/bot.png',
              ),
              height: 50,
              width: 50,
              color: Colors.black,
            ),
            Text(
              'Questionnaire Bot',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey[800],
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[400],
      items: [
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
          ),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.article_outlined,
          ),
          label: 'Daily',
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.access_time,
          ),
          label: 'Timeline',
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
          ),
          label: 'Explore',
          backgroundColor: Colors.black,
        ),
      ],
      showUnselectedLabels: true,
      onTap: _onItemTapped,
      selectedItemColor: Colors.amber[600],
      currentIndex: _selectedIndex,
    );
  }

  void _onItemTapped(int index) => setState(
        () => _selectedIndex = index,
      );

  Widget _navigationDrawerWidget() {
    return Drawer(
      child: Material(
        color: Colors.yellow,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            _buildMenuItem(
              text: 'settings',
              icon: Icons.settings,
              onClicked: () => _selectedItem(context, 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.black;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

  void _selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
        break;
    }
  }
}
