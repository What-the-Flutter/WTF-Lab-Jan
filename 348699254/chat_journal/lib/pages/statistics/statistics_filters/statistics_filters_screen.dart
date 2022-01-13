import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import 'statistics_filters_cubit.dart';
import 'statistics_filters_state.dart';

class StatisticsFiltersScreen extends StatefulWidget {
  @override
  _StatisticsFiltersScreenState createState() =>
      _StatisticsFiltersScreenState();
}

class _StatisticsFiltersScreenState extends State<StatisticsFiltersScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StatisticsFiltersCubit>(context).showActivityPages();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsFiltersCubit, StatisticsFiltersState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Align(
              child: Text('Statistics Filters'),
              alignment: Alignment.center,
            ),
          ),
          body: _bodyStructure(state),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<StatisticsFiltersCubit>(context)
                  .clearAllSelectedLists();
              if (state.selectedPageList.isNotEmpty) {
                Navigator.pop(
                  context,
                  state.selectedPageList,
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Icon(Icons.check),
          ),
        );
      },
    );
  }

  Widget _bodyStructure(StatisticsFiltersState state) {
    return Column(
      children: <Widget>[
        //_textFormFieldForSearching(state),
        Expanded(
          child: _tabBar(state),
        ),
      ],
    );
  }

  Widget _tabBar(StatisticsFiltersState state) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.amber,
              tabs: [
                Tab(
                  text: 'Pages',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _pagesTabContent(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagesTabContent(StatisticsFiltersState state) {
    final selectedPageIgnored =
        '${state.selectedPageList.length} page(s) Ignored';
    final selectedPageIncluded =
        '${state.selectedPageList.length} page(s) Included';
    return Column(
      children: [
        if (state.selectedPageList.isNotEmpty && state.arePagesIgnored)
          _startFilterContainer(selectedPageIgnored),
        if (state.selectedPageList.isNotEmpty && !state.arePagesIgnored)
          _startFilterContainer(selectedPageIncluded),
        if (state.selectedPageList.isEmpty) _startFilterContainer(pageText),
        Container(
          margin: const EdgeInsets.all(10),
          child: _ignoreSelectedPagesSwitch(state),
        ),
        _pageTagList(state),
      ],
    );
  }

  Widget _startFilterContainer(String text) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.fromLTRB(25, 30, 25, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _ignoreSelectedPagesSwitch(StatisticsFiltersState state) {
    return ListTile(
      title: const Text(
        'Ignore selected pages',
        style: TextStyle(fontSize: 16),
      ),
      subtitle:
          const Text('If enabled, the selected page(s)\nwon\'t be displayed'),
      trailing: Switch.adaptive(
        activeColor: Colors.amber,
        value: state.arePagesIgnored,
        onChanged: (value) =>
            BlocProvider.of<StatisticsFiltersCubit>(context).arePagesIgnored(),
      ),
      onTap: () {},
    );
  }

  Widget _pageTagList(StatisticsFiltersState state) {
    return Wrap(
      spacing: 10,
      children: <Widget>[
        for (var page in state.pageList)
          FilterChip(
            backgroundColor: Colors.deepPurpleAccent,
            selectedColor: Colors.purpleAccent,
            avatar: Icon(
              //_iconData[state.pageList[i].iconIndex],
              _iconData[page.iconIndex],
              color: Colors.black,
            ),
            label: Text(page.name),
            selected: BlocProvider.of<StatisticsFiltersCubit>(context)
                .isPageSelected(page),
            onSelected: (selected) =>
                BlocProvider.of<StatisticsFiltersCubit>(context)
                    .onPageSelected(page),
          ),
      ],
    );
  }

  final List<IconData> _iconData = const [
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
  ];
}
