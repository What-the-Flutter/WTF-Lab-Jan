import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../icon_list.dart';

import 'filter_page_cubit.dart';
import 'filter_page_state.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    BlocProvider.of<FilterPageCubit>(context).init();
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterPageCubit, FilterPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Filter'),
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Pages'),
                  Tab(text: 'Labels'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _columnForTabBar(
                      BlocProvider.of<FilterPageCubit>(context)
                          .state
                          .filterNotesList,
                      _generateListTile,
                      'page',
                    ),
                    _columnForTabBar(
                      BlocProvider.of<FilterPageCubit>(context)
                          .state
                          .filterLabelList,
                      _generateLabelList,
                      'label',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _columnForTabBar(
      dynamic list, List<Widget> Function() func, String text) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          height: 100,
          width: MediaQuery.of(context).size.width - 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.isNotEmpty
                ? _generateCountOfFiltersText(text, list)
                : _generateText(text),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            physics: ScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: func(),
          ),
        ),
      ],
    );
  }

  List<Widget> _generateCountOfFiltersText(String text, dynamic list) {
    return [
      Text(
        '${list.length} '
        '$text(s) included for filter',
        style: TextStyle(fontSize: 15),
      ),
    ];
  }

  List<Widget> _generateText(String text) {
    return [
      Text(
        'Tap to select a $text you want to ',
        style: TextStyle(fontSize: 15),
      ),
      Text(
        'include to the filter. All pages are ',
        style: TextStyle(fontSize: 15),
      ),
      Text(
        'included by default ',
        style: TextStyle(fontSize: 15),
      ),
    ];
  }

  List<Widget> _generateLabelList() {
    var listTileList = <Widget>[];
    for (var i = 0; i < listOfIcons.length; i++) {
      listTileList.add(
        ListView(
          children: [
            ListTile(
              title: Text(listOfIconsName[i]),
              leading: listOfIcons[i],
              onTap: () =>
                  BlocProvider.of<FilterPageCubit>(context).addIndexOfLabel(i),
            ),
            if (checkIndexInLabelList(
                BlocProvider.of<FilterPageCubit>(context).state.filterLabelList,
                i))
              Icon(Icons.check),
          ],
        ),
      );
    }
    return listTileList;
  }

  bool checkIndexInLabelList(List<int> listOfLabels, int indexOfLabel) {
    for (var i = 0; i < listOfLabels.length; i++) {
      if (listOfLabels[i] == indexOfLabel) {
        return true;
      }
    }
    return false;
  }

  List<Widget> _generateListTile() {
    var listTileList = <Widget>[];
    for (var i = 0;
        i < BlocProvider.of<FilterPageCubit>(context).state.noteList.length;
        i++) {
      listTileList.add(
        ListView(
          children: [
            ListTile(
              title: Text(BlocProvider.of<FilterPageCubit>(context)
                  .state
                  .noteList[i]
                  .noteName),
              leading: listOfIcons[BlocProvider.of<FilterPageCubit>(context)
                  .state
                  .noteList[i]
                  .indexOfCircleAvatar],
              onTap: () => BlocProvider.of<FilterPageCubit>(context).addNote(
                BlocProvider.of<FilterPageCubit>(context).state.noteList[i],
              ),
            ),
            if (BlocProvider.of<FilterPageCubit>(context)
                .state
                .noteList[i]
                .isSelected)
              Icon(Icons.check),
          ],
        ),
      );
    }
    return listTileList;
  }
}
