import 'package:flutter/material.dart';

import 'components/floating_action_button.dart';
import 'models/page_model.dart';
import 'screens/add_page_screen/add_page_screen.dart';
import 'screens/daily_screen/daily_screen.dart';
import 'screens/explore_screen/explore_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/home_screen/widgets/chat_card.dart';
import 'screens/timeline_screen/timeline_screen.dart';
import 'theme/app_colors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chat Diary',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  var _title = 'Home';

  final _listOfChats = <PageCard>[];

  @override
  void initState() {
    _listOfChats.addAll([
      PageCard(
        icon: Icons.travel_explore,
        title: 'Travel',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
      ),
      PageCard(
        icon: Icons.bed,
        title: 'Hotel',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
      ),
      PageCard(
        icon: Icons.sports_score,
        title: 'Sport',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        backgroundColor: AppColors.bluePurple,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.invert_colors),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.darkBluePurple,
        unselectedItemColor: AppColors.darkSandPurple,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
        onTap: (index) => setState(() {
          _currentIndex = index;
          switch (index) {
            case 0:
              _title = 'Home';
              break;
            case 1:
              _title = 'Daily';
              break;
            case 2:
              _title = 'Timeline';
              break;
            case 3:
              _title = 'Explore';
              break;
          }
        }),
      ),
      floatingActionButton: (_currentIndex == 0)
          ? AppFloatingActionButton(
              onPressed: () => _navigateAndFetchResult(context),
              child: const Icon(Icons.add, size: 50),
            )
          : null,
      body: IndexedStack(
        children: [
          HomeScreen(
            listOfChats: _listOfChats,
          ),
          const DailyScreen(),
          const TimelineScreen(),
          const ExploreScreen(),
        ],
        index: _currentIndex,
      ),
    );
  }

  void _navigateAndFetchResult(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPageScreen(
          title: 'Create a new Page',
        ),
      ),
    );
    if (result != null) {
      final pageModel = result as PageModel;
      final pageCard = PageCard(
        key: UniqueKey(),
        icon: pageModel.icon,
        title: pageModel.name,
        deletePage: _deleteSelectedPage,
      );
      setState(() => _listOfChats.add(pageCard));
    }
  }

  Future<void> _deleteSelectedPage(Key key) async {
    await _showDeleteDialog(key);
    setState(() {});
  }

  Future<void> _showDeleteDialog(Key key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete page?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you really sure you want to delete this page?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _listOfChats.removeWhere((element) => element.key == key);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
