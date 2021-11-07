import 'package:flutter/material.dart';
import 'screens/events_screen/event_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'theme/app_colors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chat Diary',
      //home: Home(),
      home: EventScreen(title: 'Travel'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
        onTap: (index) => setState(
          () => _currentIndex = index,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.sandPurple,
        foregroundColor: AppColors.black,
        splashColor: AppColors.darkSandPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {},
        child: const Icon(Icons.add, size: 50),
      ),
      body: const HomeScreen(),
    );
  }
}
