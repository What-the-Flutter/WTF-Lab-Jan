import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/constants/constants.dart';
import '../data/model/search_item_data.dart';
import '../data/repository/icons_repository.dart';
import '../data/theme/custom_theme.dart';
import '../search_messages_screen/search_message_screen.dart';
import '../settings_screen/visual_setting_cubit.dart';
import '../widgets/search_item.dart';
import 'filter_screen_cubit.dart';

class FilterScreen extends StatelessWidget {
  static const routeName = '/FilterScreen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filter'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Pages',
              ),
              Tab(
                text: 'Tags',
              ),
              Tab(
                text: 'Labels',
              ),
              Tab(
                text: 'Other',
              ),
            ],
          ),
        ),
        body: context.read<FilterScreenCubit>().state.modeFilter ==
                ModeFilter.complete
            ? TabBarView(
                children: <Widget>[
                  BlocBuilder<FilterScreenCubit, FilterScreenState>(
                    builder: (context, state) => TabItem(
                      list: state.pages,
                      typeTab: TypeTab.pages,
                      word: 'page',
                    ),
                  ),
                  BlocBuilder<FilterScreenCubit, FilterScreenState>(
                    builder: (context, state) => TabItem(
                      list: state.tags,
                      typeTab: TypeTab.tags,
                      word: 'tag',
                    ),
                  ),
                  BlocBuilder<FilterScreenCubit, FilterScreenState>(
                    builder: (context, state) => TabItem(
                      list: state.labels,
                      typeTab: TypeTab.labels,
                      word: 'label',
                    ),
                  ),
                  Center(
                    child: Text('In Future'),
                  ),
                ],
              )
            : CircularProgressIndicator(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final List<SearchItemData> list;
  final TypeTab typeTab;
  final String word;

  const TabItem({
    Key key,
    this.list,
    this.typeTab,
    this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visualSettingState = context.read<VisualSettingCubit>().state;
    final curTheme = HelpWindowTheme(
      backgroundColor: visualSettingState.helpWindowBackgroundColor,
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: visualSettingState.titleFontSize,
        color: visualSettingState.titleColor,
      ),
      contentStyle: TextStyle(
        fontSize: visualSettingState.bodyFontSize,
        color: visualSettingState.titleColor,
      ),
    );
    final searchItemTheme = SearchItemTheme(
      nameStyle: TextStyle(
        fontSize: visualSettingState.bodyFontSize,
        color: visualSettingState.titleColor,
      ),
      backgroundColor: Colors.red[200],
      radius: 30,
    );
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        HelpWindow(
          content: context.read<FilterScreenCubit>().isSelectedItem(typeTab)
              ? '${list.where((element) => element.isSelected).toList().length} $word(s) included'
              : 'Tap to select a $word you'
                  ' want to include to the filter.'
                  ' All ${word}s are included by default.',
          theme: curTheme,
        ),
        SizedBox(
          height: 50,
        ),
        Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          direction: Axis.horizontal,
          children: <Widget>[
            for (var i = 0; i < list.length; i++)
              FittedBox(
                fit: BoxFit.fitWidth,
                child: SearchItem(
                  key: ValueKey(list[i].id),
                  isSelected: list[i].isSelected,
                  name: list[i].name,
                  iconData: typeTab != TypeTab.tags
                      ? RepositoryProvider.of<IconsRepository>(context)
                          .listIcon[list[i].indexIcon]
                          .icon
                      : null,
                  onTap: () => context
                      .read<FilterScreenCubit>()
                      .selectedItem(typeTab, i),
                  theme: searchItemTheme,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
