import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_home_cubit/app_home_cubit.dart';
import 'screens/daily_screen/daily_screen.dart';
import 'screens/explore_screen/explore_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/timeline_screen/timeline_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit/theme_cubit.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
          home: BlocProvider<AppHomeCubit>(
            create: (context) => AppHomeCubit(),
            child: BlocBuilder<AppHomeCubit, AppHomeState>(
              builder: (context, state) => Home(),
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentIndex = context.read<AppHomeCubit>().state.currentIndex;
    var title = context.read<AppHomeCubit>().state.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: const Icon(Icons.invert_colors),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
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
        onTap: (index) {
          context.read<AppHomeCubit>().togglePage(index);
        },
      ),
      body: IndexedStack(
        children: [
          const HomeScreen(),
          const DailyScreen(),
          const TimelineScreen(),
          const ExploreScreen(),
        ],
        index: currentIndex,
      ),
    );
  }
}
