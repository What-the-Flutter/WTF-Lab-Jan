import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../../util/theme_bloc/theme_cubit.dart';
import '../entity/category.dart';
import 'home_page_cubit.dart';

class ChatJournalHomePage extends StatefulWidget {
  List<Category> categories;

  ChatJournalHomePage(this.categories);

  @override
  _ChatJournalHomePageState createState() => _ChatJournalHomePageState();
}

class _ChatJournalHomePageState extends State<ChatJournalHomePage> {
  late final _appBars;
  int _selectedIndex = 0;

  @override
  void initState() {
    BlocProvider.of<HomePageCubit>(context).init(initialCategories);
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
    return BlocProvider(
      create: (context) => HomePageCubit(widget.categories),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (blocContext, state) {
          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: _appBars[_selectedIndex],
            body: _bodyOfHomePageChat(state),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () => BlocProvider.of<HomePageCubit>(context).addCategory(context),
              child: const Icon(
                Icons.add_sharp,
                color: Colors.yellow,
              ),
            ),
            bottomNavigationBar: _chatBottomNavigationBar(),
          );
        },
      ),
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
          onPressed: () => BlocProvider.of<ThemeCubit>(context).changeTheme(),
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
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 1),
                child: Card(
                  child: ListTile(
                    title: Text(
                      state.categories[index - 1].title,
                    ),
                    subtitle: Text(
                      state.categories[index - 1].listMessages.isEmpty
                          ? 'No events. Click to create one.'
                          : state.categories[index - 1].listMessages.first.text,
                    ),
                    leading: CircleAvatar(
                      child: Icon(
                        state.categories[index - 1].iconData,
                      ),
                      backgroundColor: Colors.black,
                    ),
                    onLongPress: () => BlocProvider.of<HomePageCubit>(context).choseOfAction(
                      index,
                      context,
                    ),
                    onTap: () => BlocProvider.of<HomePageCubit>(context).openChat(
                      index - 1,
                      context,
                    ),
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

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);
}
