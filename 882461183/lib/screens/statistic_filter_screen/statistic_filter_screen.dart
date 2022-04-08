import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/icons.dart';
import 'statistic_filter_screen_cubit.dart';

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
    return BlocBuilder<StatisticsFiltersCubit, StatisticsFilterScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Statistics Filters'),
          ),
          body: _pageContent(state),
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

  Widget _pageContent(StatisticsFilterScreenState state) {
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
        if (state.selectedPageList.isEmpty)
          _startFilterContainer(
            'Tab to select a page you want to include to the filter. '
            'All pages are included by default.',
          ),
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

  Widget _ignoreSelectedPagesSwitch(StatisticsFilterScreenState state) {
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

  Widget _pageTagList(StatisticsFilterScreenState state) {
    return Wrap(
      spacing: 10,
      children: <Widget>[
        for (final page in state.pageList)
          ChoiceChip(
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            avatar: Icon(
              iconsData[page.iconIndex],
              color: Colors.black,
            ),
            label: Text(page.elementName),
            selected: BlocProvider.of<StatisticsFiltersCubit>(context)
                .isPageSelected(page),
            onSelected: (selected) =>
                BlocProvider.of<StatisticsFiltersCubit>(context)
                    .onPageSelected(page),
          ),
      ],
    );
  }
}
