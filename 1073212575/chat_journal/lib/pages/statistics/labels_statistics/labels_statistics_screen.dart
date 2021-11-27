import 'package:animations/animations.dart';
import 'package:chat_journal/models/filter_parameters.dart';
import 'package:chat_journal/pages/statistics/add_label/add_label_page.dart';
import 'package:chat_journal/pages/statistics/statistics_filters/statistics_filters_screen.dart';
import 'package:chat_journal/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'labels_statistics_cubit.dart';
import 'labels_statistics_state.dart';

class LabelsStatisticsPage extends StatefulWidget {
  @override
  _LabelsStatisticsPageState createState() => _LabelsStatisticsPageState();
}

class _LabelsStatisticsPageState extends State<LabelsStatisticsPage> {
  @override
  void initState() {
    BlocProvider.of<LabelsStatisticsPageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabelsStatisticsPageCubit, LabelsStatisticsPageState>(
      builder: (blocContext, state) {
        return Column(
          children: [
            Row(
              children: [
                _addLabelButton(),
                _timePeriods(state),
                _filtersButton()
              ],
            ),
            _icons(state),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Filters'),
    );
  }

  Widget _timePeriods(LabelsStatisticsPageState state) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: DropdownButton<String>(
        value: state.selectedPeriod,
        icon: Icon(
          Icons.arrow_downward,
          color: Theme.of(context).colorScheme.background,
        ),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
        ),
        underline: Container(
          height: 2,
          color: Theme.of(context).colorScheme.surface,
        ),
        onChanged: (newValue) {
          BlocProvider.of<LabelsStatisticsPageCubit>(context)
              .setPeriod(newValue!);
        },
        items: <String>[
          'Today',
          'Past 7 days',
          'Past 30 days',
          'This year',
          'All time'
        ].map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _icons(LabelsStatisticsPageState state) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: state.labels.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, i) => _icon(i, state),
      ),
    );
  }

  Widget _icon(int i, LabelsStatisticsPageState state) {
    final labelsNumber = BlocProvider.of<LabelsStatisticsPageCubit>(context)
        .labelNumber(i)
        .toString();
    return GestureDetector(
      onTap: () => _simpleDialog(context, state, i),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Icon(
                state.labels[i].icon,
                color: Theme.of(context).colorScheme.onBackground,
                size: 45,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.background,
              ),
              child: Text(
                labelsNumber,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _simpleDialog(
    BuildContext context,
    LabelsStatisticsPageState state,
    int i,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 300,
            child: AlertDialog(
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Icon(
                      state.labels[i].icon,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 45,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        BlocProvider.of<LabelsStatisticsPageCubit>(context)
                            .labelInfo(i),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () =>
                      BlocProvider.of<LabelsStatisticsPageCubit>(context)
                          .delete(state.labels[i].id),
                  icon: const Icon(Icons.delete),
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _addLabelButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: OpenContainer(
        transitionDuration: const Duration(seconds: 1),
        openBuilder: (context, _) => LabelPage(),
        closedShape: const CircleBorder(),
        closedColor: Theme.of(context).colorScheme.primary,
        closedBuilder: (context, openContainer) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          width: 50,
          height: 50,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
        ),
      ),
    );
  }

  Widget _filtersButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: IconButton(
        icon: Icon(
          Icons.filter_list_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () async {
          FilterParameters parameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatisticsFiltersPage(),
            ),
          );
          BlocProvider.of<LabelsStatisticsPageCubit>(context)
              .setFilterParameters(parameters);
        },
      ),
    );
  }
}
