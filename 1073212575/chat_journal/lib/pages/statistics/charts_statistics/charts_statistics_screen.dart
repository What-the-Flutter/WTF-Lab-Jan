import 'package:chat_journal/models/filter_parameters.dart';
import 'package:chat_journal/pages/statistics/statistics_filters/statistics_filters_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'charts_statistics_cubit.dart';
import 'charts_statistics_state.dart';

class ChartsStatisticsPage extends StatefulWidget {
  @override
  _ChartsStatisticsPageState createState() => _ChartsStatisticsPageState();
}

class _ChartsStatisticsPageState extends State<ChartsStatisticsPage> {
  final _tooltip = TooltipBehavior(enable: true);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChartsStatisticsPageCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsStatisticsPageCubit, ChartsStatisticsPageState>(
      builder: (blocContext, state) {
        return Column(
          children: [
            Row(
              children: [
                _timePeriods(state),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _filtersButton(),
                  ),
                ),
              ],
            ),
            _icons(state),
            _graphic(state),
          ],
        );
      },
    );
  }

  Widget _timePeriods(ChartsStatisticsPageState state) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
          BlocProvider.of<ChartsStatisticsPageCubit>(context)
              .onPeriodSelected(newValue!);
        },
        items: <String>[
          'Today',
          'Past 7 days',
          'Past 30 days',
          'This year',
        ].map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
          BlocProvider.of<ChartsStatisticsPageCubit>(context)
              .setFilterParameters(parameters);
          BlocProvider.of<ChartsStatisticsPageCubit>(context).setSummaryData();
        },
      ),
    );
  }

  Widget _icons(ChartsStatisticsPageState state) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: state.labels.length,
        itemBuilder: (context, i) => _icon(i, state),
      ),
    );
  }

  Widget _icon(int i, ChartsStatisticsPageState state) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ChartsStatisticsPageCubit>(context)
            .onLabelPressed(state.labels[i]);
      },
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
            Visibility(
              visible: BlocProvider.of<ChartsStatisticsPageCubit>(context)
                  .isLabelSelected(state.labels[i]),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Icon(
                  Icons.check,
                  size: 8,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _graphic(ChartsStatisticsPageState state) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: _tooltip,
      series: state.series,
    );
  }
}
