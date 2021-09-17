import 'package:flutter/material.dart';

import '../../util/application_theme.dart';
import '../chat_page/chat_page.dart';
import '../entity/category.dart';
import '../navbar_pages/daily_page/daily_page.dart';
import '../navbar_pages/explore_page/explore_page.dart';
import '../navbar_pages/timeline_page/timeline_page.dart';
import 'chose_of_action.dart';

class ChatJournalHomePage extends StatefulWidget {
  List<Category> categories;

  ChatJournalHomePage(this.categories);

  @override
  _ChatJournalHomePageState createState() => _ChatJournalHomePageState();
}

const String _titleForBlankScreen = 'No events. Click to create one';

class _ChatJournalHomePageState extends State<ChatJournalHomePage> {
  late List<Category> categories;
  late final _screens;
  late final _appBars;

  @override
  void initState() {
    categories = widget.categories;
    _screens = [
      _bodyOfHomePageChat(),
      DailyPage(categories: categories),
      TimelinePage(categories: categories),
      ExplorePage(categories: categories)
    ];
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
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: _appBars[_selectedIndex],
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final category = await Navigator.of(context).pushNamed('/add_page') as Category;
          setState(
            () {
              categories.add(category);
            },
          );
        },
        child: const Icon(
          Icons.add_sharp,
          color: Colors.yellow,
        ),
      ),
      bottomNavigationBar: _chatBottomNavigationBar(),
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
          onPressed: () => ThemeChanger.instanceOf(context).changeTheme(),
          icon: const Icon(
            Icons.invert_colors,
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {},
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
          style: TextStyle(color: Colors.white),
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
        onPressed: () {},
        icon: const Icon(
          Icons.list,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _bodyOfHomePageChat() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: categories.length + 1,
            itemBuilder: (
              context,
              index,
            ) {
              if (index == 0) {
                return _firstConditionPadding();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 1),
                child: Card(
                  child: ListTile(
                    title: Text(
                      categories[index - 1].title,
                    ),
                    subtitle: Text(
                      categories[index - 1].subtitle,
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Icon(
                        categories[index - 1].iconData,
                      ),
                      backgroundColor: Colors.black,
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => ChoseOfAction(
                          context,
                          categories,
                          index - 1,
                        ),
                      );
                      setState(
                        () {
                          categories = categories;
                        },
                      );
                    },
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          category: categories[index - 1],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
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
            const EdgeInsets.fromLTRB(
              1,
              1,
              1,
              1,
            ),
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

  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }
}
