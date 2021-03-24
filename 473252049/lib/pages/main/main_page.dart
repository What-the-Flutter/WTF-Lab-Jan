import 'package:chat_journal/pages/search_record_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../category/cubit/records_cubit.dart';
import '../category/dialogs/delete_records_dialog.dart';
import '../category_add_edit_page.dart';
import '../settings/cubit/settings_cubit.dart';
import 'components/main_page_bottom_navigation_bar.dart';
import 'components/main_page_drawer.dart';
import 'tabs/home/cubit/categories_cubit.dart';
import 'tabs/home/home_tab.dart';
import 'tabs/timeline/timeline_tab.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  int currentPageIndex = 0;

  void _onTabTap(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: currentPageIndex == 2 &&
                  state.records.map((e) => e.isSelected).contains(true)
              ? AppBar(
                  title: Text('Select'),
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      context.read<RecordsCubit>().unselectAll();
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.bookmark_outlined),
                      onPressed: () async {
                        await context.read<RecordsCubit>().changeFavorite(
                              state.records
                                  .where(
                                    (element) => element.isSelected,
                                  )
                                  .toList(),
                            );
                        await context.read<RecordsCubit>().unselectAll(
                              records: state.records,
                            );
                      },
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          context.read<RecordsCubit>().copyToClipboard(
                              records: state.records
                                  .where(
                                    (element) => element.isSelected,
                                  )
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
                    )
                  ],
                )
              : AppBar(
                  title: Text(
                    _tabNames[currentPageIndex],
                  ),
                  actions: [
                    if (currentPageIndex == 2)
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: SerachRecordPage(
                              context: context,
                              records: state.records,
                            ),
                          );
                        },
                      ),
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
