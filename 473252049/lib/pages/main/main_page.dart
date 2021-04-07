import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../category/cubit/records_cubit.dart';
import '../category/dialogs/delete_records_dialog.dart';
import '../category_add_edit/category_add_edit_page.dart';
import '../search_record_page.dart';
import '../settings/cubit/settings_cubit.dart';
import 'components/main_page_bottom_navigation_bar.dart';
import 'components/main_page_drawer.dart';
import 'components/show_favorite_icon_button.dart';
import 'tabs/home/cubit/categories_cubit.dart';
import 'tabs/home/home_tab.dart';
import 'tabs/timeline/timeline_tab.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final _children = [
    HomeTab(),
    Placeholder(),
    TimelineTab(),
    Placeholder(),
  ];

  final _tabNames = [
    'Home',
    'Daily',
    'Timeline',
    'Explore',
  ];

  AnimationController menuUnselectController;

  int currentPageIndex = 0;

  void _onTabTap(int index) {
    setState(() {
      currentPageIndex = index;
    });
    context.read<RecordsCubit>().unselectAll();
  }

  @override
  void initState() {
    super.initState();

    menuUnselectController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
  }

  @override
  void dispose() {
    menuUnselectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        bool isSelectedRecord() {
          if (state is RecordsLoadInProcess) return false;
          return state.records.map((e) => e.record.isSelected).contains(true) &&
              !(state is RecordsLoadInProcess);
        }

        if (isSelectedRecord() && currentPageIndex == 2) {
          menuUnselectController.forward();
        } else {
          menuUnselectController.reverse();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isSelectedRecord() && currentPageIndex == 2
                  ? 'Select'
                  : _tabNames[currentPageIndex],
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: menuUnselectController,
                  ),
                  onPressed: () {
                    menuUnselectController.status == AnimationStatus.completed
                        ? context.read<RecordsCubit>().unselectAll()
                        : Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              if (currentPageIndex == 2 && isSelectedRecord())
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.bookmark_outlined),
                      onPressed: () async {
                        await context.read<RecordsCubit>().changeFavorite(
                              state.records
                                  .where((element) => element.record.isSelected)
                                  .map((e) => e.record)
                                  .toList(),
                            );
                        await context.read<RecordsCubit>().unselectAll(
                            records:
                                state.records.map((e) => e.record).toList());
                      },
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          context.read<RecordsCubit>().copyToClipboard(
                              records: state.records
                                  .where((element) => element.record.isSelected)
                                  .map((e) => e.record)
                                  .toList());
                          context.read<RecordsCubit>().unselectAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied to clipboard'),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDeleteRecordsDialog(context);
                      },
                    ),
                  ],
                ),
              if (!isSelectedRecord() && currentPageIndex == 2)
                Row(
                  children: [
                    ShowFavoriteRecordsIconButton(state: state),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: SearchRecordPage(
                            context: context,
                            records: state.records,
                            withCategories: true,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              if (!isSelectedRecord())
                IconButton(
                  icon: Icon(
                    context.read<SettingsCubit>().state.themeMode ==
                            ThemeMode.light
                        ? Icons.bedtime_outlined
                        : Icons.bedtime,
                  ),
                  onPressed: () {
                    context.read<SettingsCubit>().switchThemeMode();
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
      },
    );
  }
}
