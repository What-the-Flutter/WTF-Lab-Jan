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
  final _listOfChats = <PageCard>[
    const PageCard(icon: Icons.travel_explore, title: 'Travel'),
    const PageCard(icon: Icons.bed, title: 'Hotel'),
    const PageCard(icon: Icons.sports_score, title: 'Sport'),
  ];

  @override
  void initState() {
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
        builder: (context) => const AddPageScreen(),
      ),
    );
    if (result != null) {
      final pageModel = result as PageModel;
      final pageCard = PageCard(
        icon: pageModel.icon,
        title: pageModel.name,
      );

      setState(() => _listOfChats.add(pageCard));
    }
  }
}
