import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/daily_screen/daily_screen.dart';
import 'screens/explore_screen/explore_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/timeline_screen/timeline_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit/theme_cubit.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.currentTheme,
          title: 'Chat Diary',
          home: const Home(),
        ),
      ),
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
  String _title = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () => BlocProvider.of<ThemeCubit>(context).toggleTheme(),
            icon: const Icon(Icons.invert_colors),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      body: IndexedStack(
        children: [
          const HomeScreen(),
          const DailyScreen(),
          const TimelineScreen(),
          const ExploreScreen(),
        ],
        index: _currentIndex,
      ),
    );
  }
}
