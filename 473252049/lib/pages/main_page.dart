import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/main_page_bottom_navigation_bar.dart';
import '../components/main_page_drawer.dart';
import '../cubits/categories/categories_cubit.dart';
import '../cubits/records/records_cubit.dart';
import '../repositories/local_database/local_database_records_repository.dart';
import '../tabs/timeline_tab.dart';
import '../tabs/home_tab.dart';
import '../thememode_cubit/thememode_cubit.dart';
import 'category_add_edit_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _children = [
    HomeTab(),
    Placeholder(),
    BlocProvider(
      create: (context) => RecordsCubit(
        LocalDatabaseRecordsRepository(),
      )..loadRecords(),
      child: TimelineTab(),
    ),
    Placeholder(),
  ];

  final _tabNames = [
    'Home',
    'Daily',
    'Timeline',
    'Explore',
  ];

  int currentPageIndex = 0;

  void _onTabTap(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tabNames[currentPageIndex],
        ),
        actions: [
          IconButton(
            icon: Icon(
              context.read<ThememodeCubit>().state.themeMode == ThemeMode.light
                  ? Icons.bedtime_outlined
                  : Icons.bedtime,
            ),
            onPressed: () {
              context.read<ThememodeCubit>().switchThemeMode();
            },
          ),
        ],
      ),
      body: _children[currentPageIndex],
      drawer: MainPageDrawer(),
      bottomNavigationBar:
          MainPageBottomNavigationBar(currentPageIndex, _onTabTap),
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return BlocProvider.value(
                        value: BlocProvider.of<CategoriesCubit>(context),
                        child: CategoryAddEditPage(
                          mode: CategoryAddEditMode.add,
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : null,
    );
  }
}
